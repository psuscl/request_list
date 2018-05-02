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

    RequestList.prototype.getList = function() {
	return JSON.parse(this.cookie("list_contents"));
    };

    RequestList.prototype.setList = function(list) {
	this.cookie("list_contents", JSON.stringify(list));
    };

    RequestList.prototype.isInList = function(uri) {
	var list = this.getList();
	return !($.inArray(uri, list) == -1);
    };

    RequestList.prototype.updateButtonState = function() {
	var button = $("#request_list_action_button");
	if (button.length > 0) {
	    if (this.isInList(button.data("uri"))) {
		var i = button.find("i." + button.data("add-icon"));
		if (i) {
		    i.removeClass(button.data("add-icon"));
		    i.addClass(button.data("remove-icon"));
		    button.attr("title", button.data("remove-label"));
		    button.html(button.html().replace(button.data("add-label"), button.data("remove-label")));
		}
	    } else {
		var i = button.find("i." + button.data("remove-icon"));
		if (i) {
		    i.removeClass(button.data("remove-icon"));
		    i.addClass(button.data("add-icon"));
		    button.attr("title", button.data("add-label"));
		    button.html(button.html().replace(button.data("remove-label"), button.data("add-label")));
		}
	    }
	}
    };

    RequestList.prototype.showListCount = function(flash) {
	var items = this.getList().length;
	var a = $("a[href='/plugin/request_list']").first();
	a.html(a.html().replace(/ \(\d+\)/, " (" + items + ")"));
	if (flash) {
	    a.parent().fadeOut(100).fadeIn(100).fadeOut(100).fadeIn(100);
	}
    };

    RequestList.prototype.addToList = function(uri) {
	var list = this.getList();
	if (this.isInList(uri)) {
	    return false;
	} else {
	    list.push(uri);
	    this.setList(list);
	    this.showListCount(true);
	    return true;
	}
    };

    RequestList.prototype.removeFromList = function(uri) {
	var list = this.getList();
	if (this.isInList(uri)) {
	    list.splice($.inArray(uri, list), 1);
	    this.setList(list);
	    this.showListCount(true);
	    if (list.length == 0) {
		location.reload(true);
	    }
	    return true;
	} else {
	    return false;
	}
    };

    RequestList.prototype.toggleListItem = function(uri) {
	if (this.isInList(uri)) {
	    this.removeFromList(uri);
	} else {
	    this.addToList(uri);
	}
	this.updateButtonState();
    };

    RequestList.prototype.setUpList = function() {
	if (!this.cookie("list_contents")) {
	    this.setList([]);
	}
	    
	this.updateButtonState();
	this.showListCount();
    };

    exports.RequestList = RequestList;

}(window));
