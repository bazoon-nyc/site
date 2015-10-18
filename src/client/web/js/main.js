/**
 * Foundation init.
 */
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
            if ($(this).val() === '') {
                isValid = false;
            }
        });

        return isValid;
    }

    /**
     * getCookie() - get CSRF cookie.
     */
    function getCookie(name) {
        var cookieValue = null;

        if (document.cookie && document.cookie != '') {
            var cookies = document.cookie.split(';');

            for (var i = 0; i < cookies.length; i++) {
                var cookie = jQuery.trim(cookies[i]);

                if (cookie.substring(0, name.length + 1) == (name + '=')) {
                    cookieValue = decodeURIComponent(cookie.substring(name.length + 1));

                    break;
                }
            }
        }

        return cookieValue;
    }

    /**
     * csrfSafeMethod() - these HTTP methods do not require CSRF protection.
     */
    function csrfSafeMethod(method) {
        return (/^(GET|HEAD|OPTIONS|TRACE)$/.test(method));
    }

    /**
     * sameOrigin() - test that a given url is a same-origin URL.
     * Url could be relative or scheme relative or absolute.
     */
    function sameOrigin(url) {
        var host = document.location.host,
            protocol = document.location.protocol,
            sr_origin = '//' + host,
            origin = protocol + sr_origin;

        return (url == origin || url.slice(0, origin.length + 1) == origin + '/') ||
            (url == sr_origin || url.slice(0, sr_origin.length + 1) == sr_origin + '/') ||
            !(/^(\/\/|http:|https:).*/.test(url));
    }

    /**
     * sendData() - send data via post request.
     */
    function sendData(data, successCb, errorCb) {
        var csrftoken = getCookie('csrftoken');

        $.ajaxSetup({
            beforeSend: function(xhr, settings) {
                if (!csrfSafeMethod(settings.type) && sameOrigin(settings.url)) {
                    xhr.setRequestHeader("X-CSRFToken", csrftoken);
                }
            }
        });

        $.ajax({
            url: '/api/messages/',
            dataType: 'json',
            type: 'post',
            contentType: 'application/json',
            data: JSON.stringify(data),
            processData: false,
            success: function(data, textStatus, jQxhr) {
                successCb(data);
            },
            error: function(jqXhr, textStatus, errorThrown) {
                errorCb(errorThrown);
            }
        });
    }

    /**
     * Catch form submit event.
     */
    $('#form-contact').on('submit', function(e) {
        e.preventDefault();

        var data = $("#form-contact :input").serializeArray(),
            successPromptEl = $("#form-contact-success-prompt"),
            fieldNamePrefix = 'form-contact-',
            cleanData = {};

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

                            cleanData[obj['name'].split(fieldNamePrefix).pop()] = obj['value'];
                        }
                    }
                }
            }
        }


        if (validateForm('#form-contact')) {
            sendData(
                cleanData,
                function success(data) {
                    successPromptEl.removeClass('hidden');
                },
                function error(data) {}
            );

            $('#form-contact')[0].reset();
        }
    });
});
