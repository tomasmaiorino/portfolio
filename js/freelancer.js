// Freelancer Theme JavaScript

(function($) {
    "use strict"; // Start of use strict

    // jQuery for page scrolling feature - requires jQuery Easing plugin
    $('.page-scroll a').bind('click', function(event) {
        var $anchor = $(this);
        $('html, body').stop().animate({
            scrollTop: ($($anchor.attr('href')).offset().top - 50)
        }, 1250, 'easeInOutExpo');
        event.preventDefault();
    });

    // Highlight the top nav as scrolling occurs
    $('body').scrollspy({
        target: '.navbar-fixed-top',
        offset: 51
    });

    // Closes the Responsive Menu on Menu Item Click
    $('.navbar-collapse ul li a').click(function(){
            $('.navbar-toggle:visible').click();
    });

    // Offset for Main Navigation
    $('#mainNav').affix({
        offset: {
            top: 100
        }
    })

    // Floating label headings for the contact form
    $(function() {
        $("body").on("input propertychange", ".floating-label-form-group", function(e) {
            $(this).toggleClass("floating-label-form-group-with-value", !!$(e.target).val());
        }).on("focus", ".floating-label-form-group", function() {
            $(this).addClass("floating-label-form-group-with-focus");
        }).on("blur", ".floating-label-form-group", function() {
            $(this).removeClass("floating-label-form-group-with-focus");
        });
        $("[rel=tooltip]").tooltip({html:true});

        var content= "<ul class='ul_n_project_1'><li>Developed all the integrations between ecommerce (ATG 11) and client's ERP. It was cover the  It was developed using ATG 11, RQL's, BCC projects workflow and Soap Webservices.</li></ul>";
        $('#n_project_1').attr('data-original-title', content);
    });

})(jQuery); // End of use strict


function showItem(className) {
  if ($(className).hasClass('hide')) {
    $(className).removeClass('hide');
  } else {
    $(className).addClass('hide');
  }
}

function resetColors(elem) {
  $.each(elem, function(i, val) {
    $(val).attr('class', '');
    $(val).addClass('color-text');
  });
}

function openMainProject(divToRemoveTranparent, show) {
  resetColors($(divToRemoveTranparent).find('li'));
  if (show != undefined && show === true) {
    $(divToRemoveTranparent).find('li').each(function(){
      $(this).show('slow');
    });
    $(divToRemoveTranparent).removeClass('transparent');
    return;
  }
  if ($(divToRemoveTranparent).hasClass('transparent')) {
    $(divToRemoveTranparent).find('li').each(function(){
      $(this).show('slow');
    });
    $(divToRemoveTranparent).removeClass('transparent');
  } else {
    $(divToRemoveTranparent).find('li').each(function(){
      $(this).hide('slow');
    });
    $(divToRemoveTranparent).addClass('transparent');
    $(divToRemoveTranparent).find('ul > :first-child').show('slow');
  }



}
