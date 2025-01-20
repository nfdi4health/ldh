function hide_field() {
        //resource = serialize()
        check_ID = $j('input[name="project[extended_metadata_attributes][data][resource_identifier_Project]"]').val();



        if (check_ID == '') {
            //$j('select[name="studyhub_resource[custom_metadata_attributes][data][resource_use_rights_label]"]').val('Not applicable');
            //$j('input:text[name^="project[extended_metadata_attributes][data][resource_identifier_Project]"]').parent().parent().hide();
            $("input:text[name='project[extended_metadata_attributes][data][Resource_identifier_Project]']").parent().hide();

        }
        else {
            $("input:text[name='project[extended_metadata_attributes][data][Resource_identifier_Project]']").parent().hide();
            $("label").text(function(index, currenText){return currenText+':'+value;});
        }

        /*if (check_license.startsWith('CC')) {
            $j('input:radio[name^="studyhub_resource[custom_metadata_attributes][data][resource_use_rights_authors_confirmation"]').parent().parent().show();
            $j('input:radio[name="studyhub_resource[custom_metadata_attributes][data][resource_use_rights_support_by_licencing]"]').parent().parent().show();
        }else {
            $j('input:radio[name^="studyhub_resource[custom_metadata_attributes][data][resource_use_rights_authors_confirmation"]').parent().parent().hide();
            $j('input:radio[name="studyhub_resource[custom_metadata_attributes][data][resource_use_rights_support_by_licencing]"]').parent().parent().hide();
        }*/

    }