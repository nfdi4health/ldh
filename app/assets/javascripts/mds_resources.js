var MDS = {
    hide_field: function() {
        $j('.form-group').each(function () {
            var title = $j(this).data('attribute-title');
            var value = $j(this).data('attribute-value');
            if (title === "Resource_identifier_Project" && (value === "" || value === null )) {
                $j(this).hide();
                //$j(this).find('input').prop('disabled', true);//, select, textarea
            }
        });
    }
}


$j(document).ready(function () {
    MDS.hide_field();
});


$j(document).on('change keyup', '#extended_metadata_attributes_extended_metadata_type_id', function () {
    MDS.hide_field();
});
