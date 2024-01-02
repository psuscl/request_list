$(function() {

  $("#request_type_select").change(function() {
    var selected = this.selectedOptions[0];
    var inputs = JSON.parse(selected.getAttribute("value"));
    for(var name in inputs) {
      $(this).parents('.rl-form').find("input[name=" + name + "]").attr("value", inputs[name]);
    }
    $('.rl-ha-options-form').hide();
    $('.rl-ha-item-form').hide();
    if (selected.text == 'Reading room') {
      $("#rl-readingroom-options-form").show();
      $(".rl-ha-additional-fields").slideDown();
      $('.rl-ha-questions-label').html($('.rl-ha-questions-label').data('other-label'));
      $('.rl-ha-questions-input').attr('title', $('.rl-ha-questions-input').data('other-help'));
    } else if (selected.text == 'Saved') {
      $("#rl-saved-options-form").show();
      $(".rl-ha-additional-fields").slideDown();
      $('.rl-ha-questions-label').html($('.rl-ha-questions-label').data('other-label'));
      $('.rl-ha-questions-input').attr('title', $('.rl-ha-questions-input').data('other-help'));
    } else if (selected.text == 'Photoduplication') {
      $("#rl-photoduplication-options-form").show();
      $(".rl-ha-additional-fields").slideDown();
      $('.rl-ha-questions-label').html($('.rl-ha-questions-label').data('photoduplication-label'));
      $('.rl-ha-questions-input').attr('title', $('.rl-ha-questions-input').data('photoduplication-help'));
    } else {
      $(".rl-ha-additional-fields").slideUp('normal', function() {
        var form = $(".rl-ha-options-form");
        form.hide();
        form.find("select").val("");
        form.find("textarea").val("");
        form.find("input").val("");
      });
    }
  });


  $('.rl-ha-list-input').on('change keyup paste', function() {
    $(this).css('border', '1px solid #ccc');
    var srcVal = $(this).val();
    if (srcVal.length > 20) { srcVal = srcVal.substr(0,20) + '...' }
    var itemForms = $('.rl-ha-item-form-' + $(this).parents('.rl-ha-options-form').data('request-type'));
    itemForms.find('[name^="' + $(this).attr('name') + '_"]').attr('placeholder', srcVal);

    if ($(this).is('select')) {
      var selected = this.selectedOptions[0].text;
      if (selected != '...') { selected = '(' + selected + ')' }

      itemForms.find('select[name^="' + $(this).attr('name') + '_"]').children('option:first-child').text(selected);
    }
  });

  $('.rl-ha-item-input').on('change keyup paste', function() {
    var allInputs = $(this).parents('.rl-ha-item-form-table').find('.rl-ha-item-input');
    if (allInputs.filter(function() { return $(this).val() != ''}).length > 0) {
      $(this).parents('.rl-list-item').find('.rl-edited-indicator').show();
    } else {
      $(this).parents('.rl-list-item').find('.rl-edited-indicator').hide();
    }
  });

  $('.rl-ha-expand-help').click(function(e) {
    $('.rl-ha-expanded-help').slideToggle('normal', function() {
      var expandHelp = $('.rl-ha-expand-help');
      var label = expandHelp.data('expand-label');
      if ($(this).is(':visible')) {
        label = expandHelp.data('collapse-label');
      }
      expandHelp.html(label);
    });
  });

});
