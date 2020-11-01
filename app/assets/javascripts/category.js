$(document).ready(function () {

  function childBuild(children) {
    let child_category = `
                        <li class="category_child">
                          <a href="#"><input class="child_btn" type="button" value="${children.name}" name= "${children.id}">
                          </a>
                        </li>
                        `
    return child_category;
  }

  function gcBuild(children) {
    let gc_category = `
                        <li class="category_grandchild">
                          <a href="#"><input class="gc_btn" type="button" value="${children.name}" name= "${children.id}">
                          </a>
                        </li>
                        `
    return gc_category;
  }

  $('#categoBtn').hover(function (e) {
    e.preventDefault();
    e.stopPropagation();
    timeOut = setTimeout(function () {
      $('#tree_menu').show();
      $('.categoryTree').show();
    }, 500)
  }, function () {
    clearTimeout(timeOut)
  });

  $('.parent_btn').hover(function () {
    $('.parent_btn').css('color', '');
    $('.parent_btn').css('background-color', '');
    let categoryParent = $(this).attr('name');
    timeParent = setTimeout(function () {
      $.ajax({
          url: '/categories/search',
          type: 'GET',
          data: {
            parent_id: categoryParent
          },
          dataType: 'json'
        })
        .done(function (data) {
          $(".categoryTree-grandchild").hide();
          $(".category_child").remove();
          $(".category_grandchild").remove();
          $('.categoryTree-child').show();
          data.forEach(function (child) {
            let child_html = childBuild(child)
            $(".categoryTree-child").append(child_html);
          });
          $('#tree_menu').css('max-height', '490px');
        })
        .fail(function () {
          alert("カテゴリーを選択してください");
        });
    }, 400)
  }, function () {
    clearTimeout(timeParent);
  });

  $(document).on({
    mouseenter: function () {
      $('.child_btn').css('color', '');
      $('.child_btn').css('background-color', '');
      let categoryChild = $(this).attr('name');
      timeChild = setTimeout(function () {
        $.ajax({
            url: '/categories/search',
            type: 'GET',
            data: {
              children_id: categoryChild
            },
            dataType: 'json'
          })
          .done(function (gc_data) {
            $(".category_grandchild").remove();
            $('.categoryTree-grandchild').show();
            gc_data.forEach(function (gc) {
              let gc_html = gcBuild(gc)
              $(".categoryTree-grandchild").append(gc_html);
              let parcol = $('.categoryTree').find(`input[name="${gc.root}"]`);
              $(parcol).css('color', 'white');
              $(parcol).css('background-color', '#b1e9eb');
            });
            $('#tree_menu').css('max-height', '490px');
          })
          .fail(function () {
            alert("カテゴリーを選択してください");
          });
      }, 400)
    },
    mouseleave: function () {
      clearTimeout(timeChild);
    }
  }, '.child_btn');

  $(document).on({
    mouseenter: function () {
      let categoryGc = $(this).attr('name');
      timeGc = setTimeout(function () {
        $.ajax({
            url: '/categories/search',
            type: 'GET',
            data: {
              gcchildren_id: categoryGc
            },
            dataType: 'json'
          })
          .done(function (gc_result) {
            let childcol = $('.categoryTree-child').find(`input[name="${gc_result[0].parent}"]`);
            $(childcol).css('color', 'white');
            $(childcol).css('background-color', '#b1e9eb');
            $('#tree_menu').css('max-height', '490px');
          })
          .fail(function () {
            alert("カテゴリーを選択してください");
          });
      }, 400)
    },
    mouseleave: function () {
      clearTimeout(timeGc);
    }
  }, '.gc_btn');


  $('#all_btn').hover(function (e) {
    e.preventDefault();
    e.stopPropagation();
    $(".categoryTree-grandchild").hide();
    $(".categoryTree-child").hide();
    $(".category_grandchild").remove();
    $(".category_child").remove();
  }, function () {
    
  });

  $(document).on({
    mouseleave: function (e) {
      e.stopPropagation();
      e.preventDefault();
      timeChosed = setTimeout(function () {
        $(".categoryTree-grandchild").hide();
        $(".categoryTree-child").hide();
        $(".categoryTree").hide();
        $(this).hide();
        $('.parent_btn').css('color', '');
        $('.parent_btn').css('background-color', '');
        $(".category_child").remove();
        $(".category_grandchild").remove();
      }, 800);
    },
    mouseenter: function () {
      clearTimeout(timeChosed);
    }
  }, '#tree_menu');

  $(document).on({
    mouseenter: function (e) {
      e.stopPropagation();
      e.preventDefault();
      timeOpened = setTimeout(function () {
        $('#tree_menu').show();
        $('.categoryTree').show();
      }, 500);
    },
    mouseleave: function (e) {
      e.stopPropagation();
      e.preventDefault();
      clearTimeout(timeOpened);
      $(".categoryTree-grandchild").hide();
      $(".categoryTree-child").hide();
      $(".categoryTree").hide();
      $("#tree_menu").hide();
      $(".category_child").remove();
      $(".category_grandchild").remove();
    }
  }, '.header__headerInner__nav__listsLeft__item');
});


