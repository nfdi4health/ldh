require 'test_helper'
require 'minitest/mock'

class NfcoreScraperTest < ActionDispatch::IntegrationTest
  setup do
    stub_request(:get, 'https://nf-co.re/pipelines.json')
      .to_return(body: File.new("#{Rails.root}/test/fixtures/files/mocking/nfcore_pipelines_trunc.json"), status: 200)
    FactoryBot.create(:nextflow_workflow_class)
  end

  test 'can scrape a new workflow' do
    project = Scrapers::Util.bot_project(title: 'test')
    bot = Scrapers::Util.bot_account
    scraper = Scrapers::NfcoreScraper.new(project, bot, organization: 'test-123', output: StringIO.new)

    repos = [FactoryBot.create(:nfcore_remote_repository)]

    scraper.stub(:clone_repositories, -> (_) { repos }) do
      assert_difference('Workflow.count', 1) do
        assert_difference('Workflow::Git::Version.count', 1) do
          assert_difference('Git::Annotation.count', 1) do
            assert_no_difference('Git::Repository.count') do
              scraped = scraper.scrape
              wf = scraped.first
              assert_equal bot, wf.contributor
              assert_equal [project], wf.projects
              assert_equal 'nf-core/rnaseq', wf.title
              assert_equal 'RNA sequencing analysis pipeline for gene/isoform quantification and extensive quality control.', wf.description
              assert_equal 'MIT', wf.license
              assert_equal 'nextflow.config', wf.main_workflow_path
              assert_equal '3.13.2', wf.git_version.name
              assert_equal %w[rna rna-seq], wf.tags.sort
            end
          end
        end
      end
    end
  end

  test 'can scrape a new version of a workflow' do
    project = Scrapers::Util.bot_project(title: 'test')
    bot = Scrapers::Util.bot_account
    scraper = Scrapers::NfcoreScraper.new(project, bot, organization: 'test-123', output: StringIO.new)

    repos = [FactoryBot.create(:nfcore_remote_repository)]

    existing = FactoryBot.create(:nfcore_git_workflow,
                                 contributor: bot,
                                 projects: [project],
                                 source_link_url: 'https://github.com/nf-core/rnaseq',
                                 git_version_attributes: { name: '2.0',
                                                           git_repository_id: repos.first.id,
                                                           ref: 'refs/tags/2.0',
                                                           commit: 'bc5fc76',
                                                           main_workflow_path: 'nextflow.config',
                                                           mutable: false })

    scraper.stub(:clone_repositories, -> (_) { repos }) do
      assert_no_difference('Workflow.count') do
        assert_difference('Workflow::Git::Version.count', 1) do
          assert_difference('Git::Annotation.count', 1) do
            assert_no_difference('Git::Repository.count') do
              scraped = scraper.scrape
              wf = scraped.first
              assert_equal 2, existing.reload.git_versions.count
              assert_equal existing, wf
              assert_equal bot, wf.contributor
              assert_equal [project], wf.projects
              assert_equal 'nf-core/rnaseq', wf.title
              assert_equal 'RNA sequencing analysis pipeline for gene/isoform quantification and extensive quality control.', wf.description
              assert_equal 'MIT', wf.license
              assert_equal 'nextflow.config', wf.main_workflow_path
              assert_equal '3.13.2', wf.git_version.name
            end
          end
        end
      end
    end
  end

  test 'does not register duplicates' do
    project = Scrapers::Util.bot_project(title: 'test')
    bot = Scrapers::Util.bot_account
    scraper = Scrapers::NfcoreScraper.new(project, bot, organization: 'test-123', output: StringIO.new)

    repos = [FactoryBot.create(:nfcore_remote_repository)]

    existing = FactoryBot.create(:nfcore_git_workflow,
                                 contributor: bot,
                                 projects: [project],
                                 source_link_url: 'https://github.com/nf-core/rnaseq',
                                 git_version_attributes: { name: '3.13.2',
                                                           git_repository_id: repos.first.id,
                                                           ref: 'refs/tags/3.13.2',
                                                           commit: 'a10f41a',
                                                           main_workflow_path: 'nextflow.config',
                                                           mutable: false })

    scraper.stub(:clone_repositories, -> (_) { repos }) do
      assert_no_difference('Workflow.count') do
        assert_no_difference('Workflow::Git::Version.count') do
          assert_no_difference('Git::Annotation.count') do
            assert_no_difference('Git::Repository.count') do
              scraped = scraper.scrape
              assert scraped.empty?
            end
          end
        end
      end
    end
  end

  test 'can scrape all tags (and skips duplicates)' do
    project = Scrapers::Util.bot_project(title: 'test')
    bot = Scrapers::Util.bot_account
    scraper = Scrapers::NfcoreScraper.new(project, bot, organization: 'test-123', output: StringIO.new, only_latest: false)

    repos = [FactoryBot.create(:nfcore_remote_repository)]
    # These are the available remote Git tags in the above repo:
    tags = ['1.0', '1.1', '1.2', '1.3', '1.4', '1.4.1', '1.4.2', '2.0', '3.0', '3.1', '3.2', '3.3', '3.4', '3.5',
            '3.6', '3.7', '3.8', '3.8.1', '3.9', '3.10', '3.10.1', '3.11.0', '3.11.1', '3.11.2', '3.12.0', '3.13.1',
            '3.13.0', '3.13.2']

    existing = FactoryBot.create(:nfcore_git_workflow,
                                 contributor: bot,
                                 projects: [project],
                                 source_link_url: 'https://github.com/nf-core/rnaseq',
                                 git_version_attributes: { name: '1.0',
                                                           git_repository_id: repos.first.id,
                                                           ref: 'refs/tags/1.0',
                                                           commit: '44f1525',
                                                           main_workflow_path: 'nextflow.config',
                                                           mutable: false })

    assert_equal 1, existing.versions.count
    scraper.stub(:clone_repositories, -> (_) { repos }) do
      assert_no_difference('Workflow.count') do
        assert_difference('Workflow::Git::Version.count', tags.count - 1) do
          assert_difference('Git::Annotation.count',  tags.count - 1) do
            assert_no_difference('Git::Repository.count') do
              scraped = scraper.scrape
              refute scraped.empty?

              assert_equal tags.count, existing.reload.versions.count
              assert_equal tags, existing.versions.sort_by(&:created_at).map(&:name)
            end
          end
        end
      end
    end
  end

  test 'does not list archived or disabled repositories' do
    project = Scrapers::Util.bot_project(title: 'test')
    bot = Scrapers::Util.bot_account
    scraper = Scrapers::NfcoreScraper.new(project, bot, organization: 'test-123', output: StringIO.new)
    repos = scraper.send(:list_repositories)
    assert_equal 1, repos.length
    assert_includes repos.map { |r| r['name'] }, 'rnaseq'
  end

  private

  def login_as(user)
    User.current_user = user
    post '/session', params: { login: user.login, password: generate_user_password }
  end
end