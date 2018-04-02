$(function() {
  var targetLeft = $('#stay_element_left');
  if(targetLeft.length) {
    var compareLeft = $('#left-fix-compare');
    if(compareLeft.height() > targetLeft.height()) {
      var parentLeft = $('#left-fix-parent');
      var fixTop = 20;
      var headY = targetLeft.offset().top - fixTop;
      var footY = parentLeft.offset().top + parentLeft.height();
      $(window).on('scroll resize', function() {
        var currentY = $(window).scrollTop();
        var currentTargetBottomY = currentY + fixTop + targetLeft.height();
        if (currentY > headY) {
          if (currentTargetBottomY <= footY) {
            targetLeft.css({
              position: 'fixed',
              top: fixTop + 'px',
              bottom: ''
            });
          } else {
            targetLeft.css({
              position: 'absolute',
              top: '',
              bottom: '0'
            });
          }
        } else {
          targetLeft.css({
            position: '',
            top: '',
            bottom: ''
          });
        }
      });
    }
  }

  var targetRight = $('#stay_element');
  if(targetRight.length){
    var parentRight = targetRight.parents('.column-container');
    var targetCompare = targetRight.parents('.column-side').prev('.column-main');
    if(targetCompare.height() > targetRight.height() && targetRight.height() > $(window).height()) {
      var fixBottom = 20;
      var footerHeight = $('body').height() - (parentRight.offset().top + parentRight.height() + parseInt(parentRight.css('padding-top'), 10));
      var targetBottomY = targetRight.offset().top + targetRight.height();
      $(window).on('scroll resize', function() {
        var currentBottomY = $(window).height() + $(window).scrollTop();
        var remainHeight = $('body').height() - currentBottomY;
        if (currentBottomY > targetBottomY + fixBottom && remainHeight >= footerHeight - fixBottom) {
          targetRight.css({
            position: 'fixed',
            bottom: fixBottom + 'px'
          });
        } else if (remainHeight < footerHeight - fixBottom) {
          targetRight.css({
            position: 'absolute',
            bottom: '0'
          });
        } else {
          targetRight.css({
            position: '',
            bottom: ''
          });
        }
      });
    }
  }

  var loginMenu = $('#login-menu');
  $('header').on('click', '#appear-menu', function() {
    if(loginMenu.css('display') == 'none') {
      loginMenu.show();
    } else {
      loginMenu.hide();
    }
  });
  $(document).on('click', function(e){
    if(!$(e.target).closest('#login-menu, #appear-menu').length){
      if(loginMenu.css('display') == 'block') {
        loginMenu.hide();
      }
    }
  });

  $('.js-fadeout').delay(4000).fadeOut(600);

  function modalClose() {
    $('.modal-overlay').fadeOut(150);
  }
  $(document).on('click', '#modal-close', function() {
    modalClose();
  });
  $(document).on('click', '.js-close-modal', function() {
    modalClose();
  });
  $(document).on('click', function(e){
    if($(e.target).hasClass('modal-overlay') && !$(e.target).closest('.modal-window').length) {
      modalClose();
    }
  });
});
