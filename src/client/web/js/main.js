$(document).foundation({
    "magellan-expedition": {
        active_class: 'active', // specify the class used for active sections
        threshold: 0, // how many pixels until the magellan bar sticks, 0 = auto
        destination_threshold: 20, // pixels from the top of destination for it to be considered active
        throttle_delay: 50, // calculation throttling to increase framerate
        fixed_top: 0, // top distance in pixels assigend to the fixed element on scroll
        offset_by_height: true // whether to offset the destination by the expedition height. Usually you want this to be true, unless your expedition is on the side.
    }
});


$(function() {

    /**
     * validateForm() - validate form by selector string.
     */
    function validateForm(formSelector) {
        var isValid = true;

        $(formSelector + ' :input').each(function() {
            if ( $(this).val() === '' )
            isValid = false;
        });

        return isValid;
    }

    $('#form-contact').on('submit', function(e) {
        e.preventDefault();

        var data = $("#form-contact :input").serializeArray();

        for (var key in data) {
            if (data.hasOwnProperty(key)) {
                var obj = data[key],
                    errorObj;

                for (var prop in obj) {
                    if (obj.hasOwnProperty(prop)){
                        errorObj = $('#error-' + obj['name']);

                        if (prop === 'value' && !obj[prop]) {
                            errorObj.removeClass('hidden');
                        } else {
                            errorObj.addClass('hidden');
                        }
                    }
                }
            }
        }


        if (validateForm('#form-contact')) {
            console.log('good');
            $('#form-contact')[0].reset();
        } else {
            console.log('bad');
        }
    });
});
