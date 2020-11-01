$(function(){
  function appendOption(category){
    var html = `<option value="${category.id}" data-category="${category.id}">${category.name}</option>`;
    return html;
  }
  function appendChidrenBox(insertHTML){
    var childSelectHtml = '';
    childSelectHtml = `<div class='Product__detail__category__select__add' id= 'children_wrapper'>
                        <div class='Product__detail__category__select__box'>
                          <select class="Product__detail__category__select__box--form" id="child_category" name="product[category_id]">
                            <option value="選択してください" data-category="選択してください">選択してください</option>
                            ${insertHTML}
                          <select>
                          <i class='Product__detail__category__select__box--arrow-down'></i>
                        </div>
                      </div>`;
    $('.Product__detail__category__select').append(childSelectHtml);
  }
  function appendGrandchidrenBox(insertHTML){
    var grandchildSelectHtml = '';
    grandchildSelectHtml = `<div class='Product__detail__category__select__add' id= 'grandchildren_wrapper'>
                              <div class='Product__detail__category__select__box'>
                                <select class="Product__detail__category__select__box--form" id="grandchild_category" name="product[category_id">
                                  <option value="選択してください" data-category="選択してください">選択してください</option>
                                  ${insertHTML}
                                <select>
                                <i class='Product__detail__category__select__box--arrow-down'></i>
                              </div>
                            </div>`;
    $('.Product__detail__category__select').append(grandchildSelectHtml);
  }
  $('#parent_category').on('change', function(){
    var parentCategory = document.getElementById('parent_category').value;
    if (parentCategory != "選択してください"){
      $.ajax({
        url: '/products/get_category_children',
        type: 'GET',
        data: { parent_name: parentCategory },
        dataType: 'json'
      })
      .done(function(children){
        $('#children_wrapper').remove();
        $('#grandchildren_wrapper').remove();
        var insertHTML = '';
        children.forEach(function(child){
          insertHTML += appendOption(child);
        });
        appendChidrenBox(insertHTML);
      })
      .fail(function(){
        alert('カテゴリー取得に失敗しました');
      })
    }else{
      $('#children_wrapper').remove();
      $('#grandchildren_wrapper').remove();
    }
  });
  $('.Product__detail__category__select').on('change', '#child_category', function(){
    var childId = $('#child_category option:selected').data('category');
    if (childId != "選択してください"){
      $.ajax({
        url: '/products/get_category_grandchildren',
        type: 'GET',
        data: { child_id: childId },
        dataType: 'json'
      })
      .done(function(grandchildren){
        console.log("1")
        if (grandchildren.length != 0) {
          $('#grandchildren_wrapper').remove();
          var insertHTML = '';
          grandchildren.forEach(function(grandchild){
            insertHTML += appendOption(grandchild);
          });
          console.log(insertHTML)
          appendGrandchidrenBox(insertHTML);
        }
      })
      .fail(function(){
        alert('カテゴリー取得に失敗しました');
      })
    }else{
      $('#grandchildren_wrapper').remove();
    }
  });
});

