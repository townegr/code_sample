$(function(){

  var requestedTab = window.location.hash.substr(1);

  $('.tab-content .tab').not('.active').hide()

  if (requestedTab) {
    $('.nav-tabs .' + requestedTab).addClass('active');
    $('.tab-content #' + requestedTab).show();
    $('.tab-content #' + requestedTab).addClass('active');

    if (requestedTab == "overview") {
      $('.current-order').find('.caption').find('h5').matchHeight();
    }

  } else {
    $('.nav-tabs .overview').addClass('active');
    $('.tab-content #overview').show();
    $('.tab-content #overview').addClass('active');
    $('.current-order').find('.caption').find('h5').matchHeight();
  }

  $('#myModal').on('shown.bs.modal', function (e) {
    $('.current-order').find('.caption').find('h5').matchHeight();
  });

  $('.payment-form').submit(function(e) {
    if ($(".payment-form input[data-stripe='number']").val()) {
      $('.payment-form').data("")
      var $form = $(this);

      // Disable the submit button to prevent repeated clicks
      $form.find('button').prop('disabled', true);

      Stripe.createToken($form, stripeResponseHandler);

      // Prevent the form from submitting with the default action
      return false;
    }
  });
});

var stripeResponseHandler = function(status, response) {
  var $form = $('.payment-form');
  var model = $("form input[name=payment_form_type]").val();

  if (response.error) {
    // Show the errors on the form
    $('.payment-errors').html("<div class='alert alert-danger' role='alert'>" + response.error.message + "</div>");
    $form.find('button').prop('disabled', false);
    $("html, body").animate({ scrollTop: 0 }, "fast");
  } else {

    // token contains id, last4, and card type
    // Insert the token into the form so it gets submitted to the server
    $form.append($('<input type="hidden" name="' + model + '[stripe_token]" />').val(response.id));
    if (model == "user") {
      $form.append($('<input type="hidden" name="' + model + '[stripe_cc_last_four]" />').val(response.card.last4));
      $form.append($('<input type="hidden" name="' + model + '[stripe_cc_type]" />').val(response.card.type));
      $form.append($('<input type="hidden" name="' + model + '[stripe_cc_exp_month]" />').val(response.card.exp_month));
      $form.append($('<input type="hidden" name="' + model + '[stripe_cc_exp_year]" />').val(response.card.exp_year));
    }
    // and re-submit
    $form.get(0).submit();
  }
};

$(document).on('click', '.nav-tabs a', function(e) {
  var currentAttrValue = $(this).attr('href');

  // Show/Hide Tabs
  $('.tabs ' + currentAttrValue).show().siblings().hide();
  // Change/remove current tab to active
  $(this).parent('li').addClass('active').siblings().removeClass('active');

  if (currentAttrValue == "#overview") {
    $('.current-order').find('.caption').find('h5').matchHeight();
  }

  e.preventDefault();
});

$(document).on('click', 'a.payment', function(e) {
  // Show/Hide Tab
  $('.tabs #shipping').show().siblings().hide();
  // Change/remove current tab to active
  $('.tabs .nav-tabs a[href$="#shipping"]').parent('li').addClass('active').siblings().removeClass('active');

  e.preventDefault();
});
