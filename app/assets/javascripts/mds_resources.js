var MDS = {
    hide_field: function() {
        $j('.form-group').each(function () {
            var title = $j(this).data('attribute-title');
            var value = $j(this).data('attribute-value');
            var all_values_json = $j(this).data('attribute-all');

            if (title === "Resource_identifier_Project" && (value === "" || value === null)) {
                $j(this).hide();
            }
            else
            {
                $j(this).show();
            }

            try {
                var all_values = JSON.parse(all_values_json.json_metadata);

                if (title === "Design_Project" && (value === "" || value === null))
                {
                    if (all_values["Resource_classification_Project"] &&
                        !(all_values["Resource_classification_Project"]["Resource_classification_type_Project"] === "Study" || all_values["Resource_classification_Project"]["Resource_classification_type_Project"] === "Substudy"
                            || all_values["Resource_classification_Project"]["Resource_classification_type_Project"] === "Registry"|| all_values["Resource_classification_Project"]["Resource_classification_type_Project"] === "Secondary data source"))
                    {
                        $j(this).hide();
                    }
                    else
                    {
                        $j(this).show();
                    }
                }
            } catch (error) {
                console.info("JSON Parse Error:", error);
            }
        });
    }
};








