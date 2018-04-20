(function(exports) {

    function RequestList() {
	this.setUpList();
    };

    RequestList.prototype.cookie = function(cookie_name, value) {
	var args = Array.prototype.slice.call(arguments, 0);
	args[0] = 'as_pui_request_list_' + args[0];
	args.push({ path: '/' });
	return $.cookie.apply(this, args);
    };

    RequestList.prototype.showListCount = function() {
	var items = JSON.parse(this.cookie("list_contents")).length;
	var a = $("a[href='/plugin/request_list']").first();
	a.html(a.html().replace(/ \(\d+\)/, " (" + items + ")"));
	a.parent().fadeOut(100).fadeIn(100).fadeOut(100).fadeIn(100);
    };

    RequestList.prototype.addToList = function(uri) {
	var list = JSON.parse(this.cookie("list_contents"));
	list.push(uri);
	this.cookie("list_contents", JSON.stringify(list));
	this.showListCount();
    };

    RequestList.prototype.setUpList = function() {
	if (!this.cookie("list_contents")) {
	    this.cookie("list_contents", JSON.stringify([]));
	}
	    
	this.showListCount();
    };

    exports.RequestList = RequestList;

}(window));
