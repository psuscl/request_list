$(function() {


  $.fn.combobox.defaults.template = '<div class="combobox-container input-group"><input type="hidden" /><input type="text" autocomplete="off"/><span class="input-group-btn btn dropdown-toggle" data-dropdown="dropdown"><span class="caret"/><span class="combobox-clear"><span class="icon-remove"></span></span></span></div>';
  $(function() {
    var initDateFields = function(scope) {
      scope = scope || $(document.body);
      $(".date-field:not(.initialised)", scope).each(function() {
        var $dateInput = $(this);

        if ($dateInput.parent().is(".input-group")) {
          $dateInput.parent().addClass("date");
        } else {
          $dateInput.wrap("<div class='input-group date'></div>");
        }

        $dateInput.addClass("initialised");

        var $addon = $("<span class='input-group-addon'><i class='glyphicon glyphicon-calendar'></i></span>");
        $dateInput.after($addon);

        $dateInput.datepicker($dateInput.data());

        $addon.on("click", function() {
          $dateInput.focus().select();
        });
      });
    };
    initDateFields();
  });


  $("#request_type_select").change(function() {
    var selected = this.selectedOptions[0];
    var inputs = JSON.parse(selected.getAttribute("value"));
    for(var name in inputs) {
      $(this).parent().parent().parent().find("input[name=" + name + "]").attr("value", inputs[name]);
    }
    $('.rl-ha-options-form').hide();
    $('.rl-ha-item-form').hide();
    if (selected.text == 'Reading room') {
      $("#rl-readingroom-options-form").show();
      $(".rl-ha-additional-fields").slideDown();
    } else if (selected.text == 'Saved') {
      $("#rl-saved-options-form").show();
      $(".rl-ha-additional-fields").slideDown();
    } else if (selected.text == 'Photoduplication') {
      $("#rl-photoduplication-options-form").show();
      $(".rl-ha-additional-fields").slideDown();
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
    $(this).css('border', 'initial');
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

});
