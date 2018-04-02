var y;
var lockTarget = $('#content-area');
function lockBackground(flg) {
  if(flg === 'lock'){
    y = $(window).scrollTop();
    lockTarget.css({
      position: 'fixed',
      width: '100%',
      top: y * -1
    });
  } else {
    lockTarget.attr({style:''});
    $('html, body').prop({scrollTop:y});
  }
}

$(function() {
  $('#toggle-menu').on('touchend touchmove', function(e) {
    e.preventDefault();
    if(!$('#content-area').hasClass('slide-left')) {
      $('#menu').removeClass('is-hide');
      $('#content-area, #header, #overlay').addClass('slide-left');
      $('#overlay').show();
      lockBackground('lock');
    }
  });
  $('#overlay').on('touchend touchmove', function(e) {
    e.preventDefault();
    $(this).hide();
    $('#content-area, #header, #overlay').removeClass('slide-left');
    $('#menu').addClass('is-hide');
    lockBackground('unlock');
  });
  $('#toggle-search').on('touchend touchmove', function(e) {
    e.preventDefault();
    $('#search-area').show();
    $('#main-area').hide();
  });
  $('#toggle-search-back').on('touchend touchmove', function(e) {
    e.preventDefault();
    $('#main-area').show();
    $('#search-area').hide();
  });

  $('#toggle-user-menu').on('touchend touchmove', function(e) {
    e.preventDefault();
    $(this).toggleClass('opened');
    $('#collapse-menu').slideToggle(200);
  });

  $('#images-order-select').on('change', function() {
    $(this).parents('form').submit();
  });

  $('#narrowing-drawer').on('touchend touchmove', function() {
    $(this).toggleClass('narrowing-button-wrap-active');
    $('#narrowing-extension').slideToggle(150);
  });
  $('#narrowing-extension-close-button').on('touchend touchmove', function() {
    $('#narrowing-drawer').toggleClass('narrowing-button-wrap-active');
    $('#narrowing-extension').slideUp(150);
  });

  $('#color-select').on('touchend touchmove', function() {
    $('#overlay-color').fadeIn(150);
    $('#overlay-color .modal-window').slideDown(150);
  });
  $('#overlay-color, #close-overlay-color').on('touchend touchmove', function() {
    $('#overlay-color').fadeOut(150);
    $('#overlay-color .modal-window').slideUp(150);
  });
  $('#overlay-color .modal-window').on('touchend touchmove', function(e) {
    e.stopPropagation();
  });

  $('#color-radio-list input[type=radio]').on('change',function(){
    var checkedColor = $(this).val();
    $('#image-color').val(checkedColor);
    $('#color-select').text(colors[checkedColor]);
    $('#overlay-color').fadeOut(150);
    $('#overlay-color .modal-window').slideUp(150);
  });

  $('#close-overlay-color').on('touchend touchmove', function() {
    $('#image-color').val('');
    $('#color-select').text(colors.none);
  });
});
