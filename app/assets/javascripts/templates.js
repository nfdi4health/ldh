var Templates = {
  table: null,
  context: { description_elem: null, suffix: null }
};

Templates.clearContext = function () {
  Templates.context = { description_elem: null, suffix: null };
};

Templates.init = function (elem) {
  const columnDefs = [
    { orderable: false, targets: [0, 7, 9] },
    {
      targets: [3, 4],
      visible: false,
      searchable: false
    },
    { defaultContent: "-", targets: "_all" }
  ];

  const columns = [
    {
      title: "Required",
      width: "5%",
      className: "text-center",
      mRender: function (data, type, full) {
        return `<td><input class='template-input' ${
          data ? "disabled checked" : ""
        } type='checkbox' onClick='handleClick(this)'/></td>`;
      }
    },
    { title: "Attribute name", width: "18%" },
    { title: "Description", width: "40%" },
    { title: "attribute_type_id" },
    { title: "cv_id" },
    { title: "Unit", width: "5%" },
    { title: "Data type", width: "10%" },
    {
      title: "Is title",
      className: "text-center",
      mRender: function (data) {
        return `<td><input class='template-input' disabled ${data ? "checked" : ""} type='checkbox' /></td>`;
      },
      width: "7%"
    },
    { title: "IRI", width: "10%" },
    {
      title: "Remove",
      width: "5%",
      className: "text-center",
      mRender: function (data, type, full) {
        return full[0]
          ? ""
          : '<a class="btn btn-danger btn-sm" href="javascript:void(0)" onClick="remove(this)">Remove</a>';
      }
    }
  ];

  Templates.table = elem.DataTable({
    columnDefs,
    columns,
    order: [[1, "asc"]],
    autoWidth: false,
    stateSave: true
  });

  loadFilterSelectors(templates);
  loadTemplates(templates);
  setTemplate();
};

const remove = (e) => Templates.table.row($j(e).closest("tr")).remove().draw();
const handleClick = (e) => (Templates.table.row($j(e).closest("tr")).data()[0] = $j(e).is(":checked"));

function loadTemplates(data) {
  $j("#source_select").empty();
  let categorizedData = data.reduce((obj, item) => {
    obj[item.group] = obj[item.group] || [];
    obj[item.group].push(item);
    return obj;
  }, {});

  $j.each(Object.keys(categorizedData), (i, key) => {
    const elem = $j(`<optgroup label=${key}></optgroup>`);
    $j.each(categorizedData[key], (j, sub_item) => {
      elem.append(
        $j(`<option>${sub_item.title}</option>`).attr("value", sub_item.template_id).text(key.title)
      );
    });
    $j("#source_select").append(elem);
  });
  setTemplate();
}

function setTemplate() {
  Templates.table.clear();
  const id = $j("#source_select").find(":selected").val();
  const data = templates.find((t) => t.template_id == id);
  Templates.table.rows.add(Templates.mapData(data.attributes)).draw();
}

Templates.mapData = (data) =>
  data.map((item) => [
    item.required,
    item.title,
    item.description,
    item.attribute_type_id,
    item.cv_id,
    item.unit_id,
    item.data_type,
    item.is_title,
    item.iri
  ]);

function loadFilterSelectors(data) {
  $j.each($j("select[id^='templates_']"), (i, elem) => {
    const key = elem.getAttribute("data-key");
    const dt = [...new Set(data.map((item) => item[key]))];
    $j(elem).find("option").not(":first").remove();
    $j.each(dt, (i, item) => $j(elem).append(`<option value="${item}">${item}</option>`));
    $j(elem).on("change", function () {
      const filters = $j("[data-key]")
        .map((i, elem) => ({ key: elem.getAttribute("data-key"), value: elem.value }))
        .toArray()
        .filter((f) => f.value != "not selected");
      let filtered = templates;
      filters.forEach(({ key, value }) => {
        filtered = filtered.filter((x) => x[key] == value);
      });
      loadTemplates(filtered || templates);
    });
  });
}

const applyTemplate = () => {
  const id = $j("#source_select").find(":selected").val();
  const data = templates.find((t) => t.template_id == id);
  const codeMirror = $j(Templates.context.description_elem || "#template-description").nextAll(
    ".CodeMirror"
  )[0].CodeMirror;
  if (data.description) codeMirror.getDoc().setValue(data.description);
  const suffix = Templates.context.suffix || "";
  const attribute_table = "#attribute-table" + suffix;
  const attribute_row = "#new-attribute-row" + suffix;
  const addAttributeRow = "#add-attribute-row" + suffix;

  $j("#template_parent_id").val(data.template_id);
  $j(`${attribute_table} tbody`).find("tr:not(:last)").remove();
  SampleTypes.unbindSortable();
  $j.each(Templates.table.rows().data(), (i, row) => {
    var newRow = $j(`${attribute_row} tbody`).clone().html();
    var index = 0;
    $j(`${attribute_table} tr.sample-attribute`).each(function () {
      var newIndex = parseInt($j(this).data("index"));
      if (newIndex > index) {
        index = newIndex;
      }
    });
    index++;

    newRow = $j(newRow.replace(/replace-me/g, index));

    $j(newRow).find('[data-attr="required"]').prop("checked", row[0]);
    $j(newRow).find('[data-attr="title"]').val(row[1]);
    $j(newRow).find('[data-attr="description"]').val(row[2]);
    $j(newRow).find('[data-attr="type"]').val(row[3]);
    $j(newRow).find('[data-attr="cv_id"]').val(row[4]);
    $j(newRow).find('[data-attr="unit"]').val(row[5]);
    $j(newRow).find(".sample-type-is-title").prop("checked", row[7]);
    $j(newRow).find('[data-attr="iri"]').val(row[8]);

    // Show the CV block if cv_id is not empty
    if (row[4]) $j(newRow).find(".controlled-vocab-block").show();

    // Show the sample-type-block block if type is SEEK sample
    const is_seek_sample = $j(newRow)
      .find(".sample-type-attribute-type")
      .find(":selected")
      .data("is-seek-sample");
    if (is_seek_sample) $j(newRow).find(".sample-type-block").show();
    // Select the first item by default
    $j(newRow).find(".linked-sample-type-selection optgroup option:first").attr("selected", "selected")

    $j(`${attribute_table} ${addAttributeRow}`).before(newRow);
  });

  // Sets the template_id in the form (if the object is an isa_study form sample_type)
  const template_id_tag = $j(`#isa_study${suffix}_template_id`);
  if (template_id_tag) $j(template_id_tag).val(id);

  SampleTypes.recalculatePositions();
  SampleTypes.bindSortable();
};

const showTemplateModal = () => {
  $j("#existing_templates").modal("show");
};