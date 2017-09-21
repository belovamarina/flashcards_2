$(document).ajaxComplete(function() {
    $(".flickr").click(function () {
        $(this).toggleClass("specialborderClass");
        $('.flickr').not(this).removeClass("specialborderClass");
        $("#card_remote_image_url").val($(this).attr("src"));
    });
});
