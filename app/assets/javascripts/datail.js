$(function(){
  $('#image-list img').hover(function(){
      $('#main-image img').attr('src', $(this).attr('src'));
  });
});