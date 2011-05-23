package Amon2::Setup::Asset::Spine;
use strict;
use warnings;
use 5.008001;
our $VERSION = '0.01';

sub spine {
q{(function(){
  
  var Spine;
  if (typeof exports !== "undefined") {
    Spine = exports;
  } else {
    Spine = this.Spine = {};
  }
  
  Spine.version = "0.0.4";
  
  var $ = Spine.$ = this.jQuery || this.Zepto || function(){ return arguments[0]; };
  
  var makeArray = Spine.makeArray = function(args){
    return Array.prototype.slice.call(args, 0);
  };
  
  // Shim Array, as these functions aren't in IE
  if (typeof Array.prototype.indexOf === "undefined")
    Array.prototype.indexOf = function(value){
      for ( var i = 0; i < this.length; i++ )
    		if ( this[ i ] === value )
    			return i;
    	return -1;
    };
  
  var Events = Spine.Events = {
    bind: function(ev, callback) {
      var evs   = ev.split(" ");
      var calls = this._callbacks || (this._callbacks = {});
      
      for (var i=0; i < evs.length; i++)
        (this._callbacks[evs[i]] || (this._callbacks[evs[i]] = [])).push(callback);

      return this;
    },

    trigger: function() {
      var args = makeArray(arguments);
      var ev   = args.shift();
            
      var list, calls, i, l;
      if (!(calls = this._callbacks)) return false;
      if (!(list  = this._callbacks[ev])) return false;
      
      for (i = 0, l = list.length; i < l; i++)
        if (list[i].apply(this, args) === false)
          break;

      return true;
    },
    
    unbind: function(ev, callback){
      if ( !ev ) {
        this._callbacks = {};
        return this;
      }
      
      var list, calls, i, l;
      if (!(calls = this._callbacks)) return this;
      if (!(list  = this._callbacks[ev])) return this;
      
      if ( !callback ) {
        delete this._callbacks[ev];
        return this;
      }
      
      for (i = 0, l = list.length; i < l; i++)
        if (callback === list[i]) {
          list.splice(i, 1);
          break;
        }
        
      return this;
    }
  };
  
  var Log = Spine.Log = {
    trace: true,
    
    logPrefix: "(App)",

    log: function(){
      if ( !this.trace ) return;
      if (typeof console == "undefined") return;
      var args = makeArray(arguments);
      if (this.logPrefix) args.unshift(this.logPrefix);
      console.log.apply(console, args);
      return this;
    }
  };
  
  // Classes (or prototypial inheritors)
  
  if (typeof Object.create !== "function")
      Object.create = function(o) {
        function F() {}
        F.prototype = o;
        return new F();
      };
      
  var moduleKeywords = ["included", "extended"];

  var Class = Spine.Class = {
    inherited: function(){},
    created: function(){},
    
    prototype: {
      initialize: function(){},
      init: function(){}
    },

    create: function(include, extend){
      var object = Object.create(this);
      object.parent    = this;
      object.prototype = object.fn = Object.create(this.prototype);

      if (include) object.include(include);
      if (extend)  object.extend(extend);

      object.created();
      this.inherited(object);
      return object;
    },

    init: function(){
      var instance = Object.create(this.prototype);
      instance.parent = this;

      instance.initialize.apply(instance, arguments);
      instance.init.apply(instance, arguments);
      return instance;
    },

    proxy: function(func){
      var thisObject = this;
      return(function(){ 
        return func.apply(thisObject, arguments); 
      });
    },
    
    proxyAll: function(){
      var functions = makeArray(arguments);
      for (var i=0; i < functions.length; i++)
        this[functions[i]] = this.proxy(this[functions[i]]);
    },

    include: function(obj){
      for(var key in obj)
        if (moduleKeywords.indexOf(key) == -1)
          this.fn[key] = obj[key];
      
      var included = obj.included;
      if (included) included.apply(this);
      return this;
    },

    extend: function(obj){
      for(var key in obj)
        if (moduleKeywords.indexOf(key) == -1)
          this[key] = obj[key];
      
      var extended = obj.extended;
      if (extended) extended.apply(this);
      return this;
    }
  };
  
  Class.prototype.proxy    = Class.proxy;
  Class.prototype.proxyAll = Class.proxyAll;
  Class.inst               = Class.init;
  Class.sub                = Class.create;

  // Models
  
  Spine.guid = function(){
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
      var r = Math.random()*16|0, v = c == 'x' ? r : (r&0x3|0x8);
      return v.toString(16);
    }).toUpperCase();      
  };

  var Model = Spine.Model = Class.create();
  
  Model.extend(Events);

  Model.extend({
    setup: function(name, atts){
      var model = Model.sub();
      if (name) model.name = name;
      if (atts) model.attributes = atts;
      return model;
    },
    
    created: function(sub){
      this.records = {};
      this.attributes = this.attributes ? 
        makeArray(this.attributes) : [];
    },

    find: function(id){
      var record = this.records[id];
      if ( !record ) throw("Unknown record");
      return record.clone();
    },

    exists: function(id){
      try {
        return this.find(id);
      } catch (e) {
        return false;
      }
    },

    refresh: function(values){
      if(Model.ajaxPrefix && this.prefix) {
        values = values[this.prefix];
      }
      values = this.fromJSON(values);
      this.records = {};

      for (var i=0, il = values.length; i < il; i++) {    
        var record = values[i];
        record.newRecord = false;
        this.records[record.id] = record;
      }

      this.trigger("refresh");
      return this;
    },

    select: function(callback){
      var result = [];

      for (var key in this.records)
        if (callback(this.records[key]))
          result.push(this.records[key]);

      return this.cloneArray(result);
    },

    findByAttribute: function(name, value){
      for (var key in this.records)
        if (this.records[key][name] == value)
          return this.records[key].clone();
    },

    findAllByAttribute: function(name, value){
      return(this.select(function(item){
        return(item[name] == value);
      }));
    },

    each: function(callback){
      for (var key in this.records)
        callback(this.records[key]);
    },

    all: function(){
      return this.cloneArray(this.recordsValues());
    },

    first: function(){
      var record = this.recordsValues()[0];
      return(record && record.clone());
    },

    last: function(){
      var values = this.recordsValues()
      var record = values[values.length - 1];
      return(record && record.clone());
    },

    count: function(){
      return this.recordsValues().length;
    },

    deleteAll: function(){
      for (var key in this.records)
        delete this.records[key];
    },

    destroyAll: function(){
      for (var key in this.records)
        this.records[key].destroy();
    },

    update: function(id, atts){
      this.find(id).updateAttributes(atts);
    },

    create: function(atts){
      var record = this.init(atts);
      return record.save();
    },

    destroy: function(id){
      this.find(id).destroy();
    },

    sync: function(callback){
      this.bind("change", callback);
    },

    fetch: function(callbackOrParams){
      typeof(callbackOrParams) == 'function' ? this.bind("fetch", callbackOrParams) : this.trigger("fetch", callbackOrParams);
    },

    toJSON: function(){
      return this.recordsValues();
    },
    
    fromJSON: function(objects){
      if ( !objects ) return;
      if (typeof objects == "string")
        objects = JSON.parse(objects)
      if (typeof objects.length == "number") {
        var results = [];
        for (var i=0; i < objects.length; i++)
          results.push(this.init(objects[i]));
        return results;
      } else {
        return this.init(objects);
      }
    },

    // Private

    recordsValues: function(){
      var result = [];
      for (var key in this.records)
        result.push(this.records[key]);
      return result;
    },

    cloneArray: function(array){
      var result = [];
      for (var i=0; i < array.length; i++)
        result.push(array[i].clone());
      return result;
    }
  });

  Model.include({
    model: true,
    newRecord: true,

    init: function(atts){
      if (atts) this.load(atts);
      this.trigger("init", this);
    },

    isNew: function(){
      return this.newRecord;
    },
    
    isValid: function(){
      return(!this.validate());
    },

    validate: function(){ },

    load: function(atts){
      for(var name in atts)
        this[name] = atts[name];
    },

    attributes: function(){
      var result = {};
      for (var i=0; i < this.parent.attributes.length; i++) {
        var attr = this.parent.attributes[i];
        result[attr] = this[attr];
      }
      result.id = this.id;
      return result;
    },

    eql: function(rec){
      return(rec && rec.id === this.id && 
             rec.parent === this.parent);
    },

    save: function(){
      var error = this.validate();
      if ( error ) {
        this.trigger("error", this, error)
        return false;
      }
      
      this.trigger("beforeSave", this);
      this.newRecord ? this.create() : this.update();
      this.trigger("save", this);
      return this;
    },

    updateAttribute: function(name, value){
      this[name] = value;
      return this.save();
    },

    updateAttributes: function(atts){
      this.load(atts);
      return this.save();
    },
    
    destroy: function(){
      this.trigger("beforeDestroy", this);
      delete this.parent.records[this.id];
      this.destroyed = true;
      this.trigger("destroy", this);
      this.trigger("change", this, "destroy");
    },

    dup: function(){
      var result = this.parent.init(this.attributes());
      result.newRecord = this.newRecord;
      return result;
    },
    
    clone: function(){
      return Object.create(this);
    },

    reload: function(){
      if ( this.newRecord ) return this;
      var original = this.parent.find(this.id);
      this.load(original.attributes());
      return original;
    },

    toJSON: function(){
      return(this.attributes());
    },
    
    exists: function(){
      return(this.id && this.id in this.parent.records);
    },

    // Private

    update: function(){
      this.trigger("beforeUpdate", this);
      var records = this.parent.records;
      records[this.id].load(this.attributes());
      var clone = records[this.id].clone();
      this.trigger("update", clone);
      this.trigger("change", clone, "update");
    },

    create: function(){
      this.trigger("beforeCreate", this);
      if ( !this.id ) this.id = Spine.guid();
      this.newRecord   = false;
      var records      = this.parent.records;
      records[this.id] = this.dup();
      var clone        = records[this.id].clone();
      this.trigger("create", clone);
      this.trigger("change", clone, "create");
    },
    
    bind: function(events, callback){
      return this.parent.bind(events, this.proxy(function(record){
        if ( record && this.eql(record) )
          callback.apply(this, arguments);
      }));
    },
    
    trigger: function(){
      return this.parent.trigger.apply(this.parent, arguments);
    }
  });
  
  // Controllers
  
  var eventSplitter = /^(\w+)\s*(.*)$/;
  
  var Controller = Spine.Controller = Class.create({
    tag: "div",
    
    initialize: function(options){
      this.options = options;

      for (var key in this.options)
        this[key] = this.options[key];

      if (!this.el) this.el = document.createElement(this.tag);
      this.el = $(this.el);

      if ( !this.events ) this.events = this.parent.events;
      if ( !this.elements ) this.elements = this.parent.elements;

      if (this.events) this.delegateEvents();
      if (this.elements) this.refreshElements();
      if (this.proxied) this.proxyAll.apply(this, this.proxied);
    },
        
    $: function(selector){
      return $(selector, this.el);
    },
        
    delegateEvents: function(){
      for (var key in this.events) {
        var methodName = this.events[key];
        var method     = this.proxy(this[methodName]);

        var match      = key.match(eventSplitter);
        var eventName  = match[1], selector = match[2];

        if (selector === '') {
          this.el.bind(eventName, method);
        } else {
          this.el.delegate(selector, eventName, method);
        }
      }
    },
    
    refreshElements: function(){
      for (var key in this.elements) {
        this[this.elements[key]] = this.$(key);
      }
    },
    
    delay: function(func, timeout){
      setTimeout(this.proxy(func), timeout || 0);
    }
  });
  
  Controller.include(Events);
  Controller.include(Log);
  
  Spine.App = Class.create();
  Spine.App.extend(Events)
  Controller.fn.App = Spine.App;
})();};
}

sub spine_min {
q{(function(){var g;if(typeof exports!=="undefined"){g=exports}else{g=this.Spine={}}g.version="0.0.4";var e=g.$=this.jQuery||this.Zepto||function(){return arguments[0]};var b=g.makeArray=function(k){return Array.prototype.slice.call(k,0)};if(typeof Array.prototype.indexOf==="undefined"){Array.prototype.indexOf=function(l){for(var k=0;k<this.length;k++){if(this[k]===l){return k}}return -1}}var j=g.Events={bind:function(n,o){var k=n.split(" ");var m=this._callbacks||(this._callbacks={});for(var l=0;l<k.length;l++){(this._callbacks[k[l]]||(this._callbacks[k[l]]=[])).push(o)}return this},trigger:function(){var m=b(arguments);var p=m.shift();var q,o,n,k;if(!(o=this._callbacks)){return false}if(!(q=this._callbacks[p])){return false}for(n=0,k=q.length;n<k;n++){if(q[n].apply(this,m)===false){break}}return true},unbind:function(o,q){if(!o){this._callbacks={};return this}var p,n,m,k;if(!(n=this._callbacks)){return this}if(!(p=this._callbacks[o])){return this}if(!q){delete this._callbacks[o];return this}for(m=0,k=p.length;m<k;m++){if(q===p[m]){p.splice(m,1);break}}return this}};var f=g.Log={trace:true,logPrefix:"(App)",log:function(){if(!this.trace){return}if(typeof console=="undefined"){return}var k=b(arguments);if(this.logPrefix){k.unshift(this.logPrefix)}console.log.apply(console,k);return this}};if(typeof Object.create!=="function"){Object.create=function(l){function k(){}k.prototype=l;return new k()}}var h=["included","extended"];var a=g.Class={inherited:function(){},created:function(){},prototype:{initialize:function(){},init:function(){}},create:function(k,m){var l=Object.create(this);l.parent=this;l.prototype=l.fn=Object.create(this.prototype);if(k){l.include(k)}if(m){l.extend(m)}l.created();this.inherited(l);return l},init:function(){var k=Object.create(this.prototype);k.parent=this;k.initialize.apply(k,arguments);k.init.apply(k,arguments);return k},proxy:function(l){var k=this;return(function(){return l.apply(k,arguments)})},proxyAll:function(){var l=b(arguments);for(var k=0;k<l.length;k++){this[l[k]]=this.proxy(this[l[k]])}},include:function(m){for(var k in m){if(h.indexOf(k)==-1){this.fn[k]=m[k]}}var l=m.included;if(l){l.apply(this)}return this},extend:function(m){for(var l in m){if(h.indexOf(l)==-1){this[l]=m[l]}}var k=m.extended;if(k){k.apply(this)}return this}};a.prototype.proxy=a.proxy;a.prototype.proxyAll=a.proxyAll;a.inst=a.init;a.sub=a.create;g.guid=function(){return"xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace(/[xy]/g,function(m){var l=Math.random()*16|0,k=m=="x"?l:(l&3|8);return k.toString(16)}).toUpperCase()};var c=g.Model=a.create();c.extend(j);c.extend({setup:function(l,m){var k=c.sub();if(l){k.name=l}if(m){k.attributes=m}return k},created:function(k){this.records={};this.attributes=this.attributes?b(this.attributes):[]},find:function(l){var k=this.records[l];if(!k){throw ("Unknown record")}return k.clone()},exists:function(l){try{return this.find(l)}catch(k){return false}},refresh:function(m){m=this.fromJSON(m);this.records={};for(var n=0,l=m.length;n<l;n++){var k=m[n];k.newRecord=false;this.records[k.id]=k}this.trigger("refresh");return this},select:function(m){var k=[];for(var l in this.records){if(m(this.records[l])){k.push(this.records[l])}}return this.cloneArray(k)},findByAttribute:function(k,m){for(var l in this.records){if(this.records[l][k]==m){return this.records[l].clone()}}},findAllByAttribute:function(k,l){return(this.select(function(m){return(m[k]==l)}))},each:function(l){for(var k in this.records){l(this.records[k])}},all:function(){return this.cloneArray(this.recordsValues())},first:function(){var k=this.recordsValues()[0];return(k&&k.clone())},last:function(){var l=this.recordsValues();var k=l[l.length-1];return(k&&k.clone())},count:function(){return this.recordsValues().length},deleteAll:function(){for(var k in this.records){delete this.records[k]}},destroyAll:function(){for(var k in this.records){this.records[k].destroy()}},update:function(l,k){this.find(l).updateAttributes(k)},create:function(l){var k=this.init(l);return k.save()},destroy:function(k){this.find(k).destroy()},sync:function(k){this.bind("change",k)},fetch:function(k){k?this.bind("fetch",k):this.trigger("fetch")},toJSON:function(){return this.recordsValues()},fromJSON:function(m){if(!m){return}if(typeof m=="string"){m=JSON.parse(m)}if(typeof m.length=="number"){var l=[];for(var k=0;k<m.length;k++){l.push(this.init(m[k]))}return l}else{return this.init(m)}},recordsValues:function(){var k=[];for(var l in this.records){k.push(this.records[l])}return k},cloneArray:function(m){var k=[];for(var l=0;l<m.length;l++){k.push(m[l].clone())}return k}});c.include({model:true,newRecord:true,init:function(k){if(k){this.load(k)}this.trigger("init",this)},isNew:function(){return this.newRecord},isValid:function(){return(!this.validate())},validate:function(){},load:function(l){for(var k in l){this[k]=l[k]}},attributes:function(){var l={};for(var m=0;m<this.parent.attributes.length;m++){var k=this.parent.attributes[m];l[k]=this[k]}l.id=this.id;return l},eql:function(k){return(k&&k.id===this.id&&k.parent===this.parent)},save:function(){var k=this.validate();if(k){this.trigger("error",this,k);return false}this.trigger("beforeSave",this);this.newRecord?this.create():this.update();this.trigger("save",this);return this},updateAttribute:function(k,l){this[k]=l;return this.save()},updateAttributes:function(k){this.load(k);return this.save()},destroy:function(){this.trigger("beforeDestroy",this);delete this.parent.records[this.id];this.destroyed=true;this.trigger("destroy",this);this.trigger("change",this,"destroy")},dup:function(){var k=this.parent.init(this.attributes());k.newRecord=this.newRecord;return k},clone:function(){return Object.create(this)},reload:function(){if(this.newRecord){return this}var k=this.parent.find(this.id);this.load(k.attributes());return k},toJSON:function(){return(this.attributes())},exists:function(){return(this.id&&this.id in this.parent.records)},update:function(){this.trigger("beforeUpdate",this);var k=this.parent.records;k[this.id].load(this.attributes());var l=k[this.id].clone();this.trigger("update",l);this.trigger("change",l,"update")},create:function(){this.trigger("beforeCreate",this);if(!this.id){this.id=g.guid()}this.newRecord=false;var k=this.parent.records;k[this.id]=this.dup();var l=k[this.id].clone();this.trigger("create",l);this.trigger("change",l,"create")},bind:function(k,l){return this.parent.bind(k,this.proxy(function(m){if(m&&this.eql(m)){l.apply(this,arguments)}}))},trigger:function(){return this.parent.trigger.apply(this.parent,arguments)}});var i=/^(\w+)\s*(.*)$/;var d=g.Controller=a.create({tag:"div",initialize:function(k){this.options=k;for(var l in this.options){this[l]=this.options[l]}if(!this.el){this.el=document.createElement(this.tag)}this.el=e(this.el);if(!this.events){this.events=this.parent.events}if(!this.elements){this.elements=this.parent.elements}if(this.events){this.delegateEvents()}if(this.elements){this.refreshElements()}if(this.proxied){this.proxyAll.apply(this,this.proxied)}},$:function(k){return e(k,this.el)},delegateEvents:function(){for(var o in this.events){var m=this.events[o];var p=this.proxy(this[m]);var n=o.match(i);var l=n[1],k=n[2];if(k===""){this.el.bind(l,p)}else{this.el.delegate(k,l,p)}}},refreshElements:function(){for(var k in this.elements){this[this.elements[k]]=this.$(k)}},delay:function(k,l){setTimeout(this.proxy(k),l||0)}});d.include(j);d.include(f);g.App=a.create();g.App.extend(j);d.fn.App=g.App})();};
}

sub spine_list {
q{(function(Spine, $){
  
  Spine.List = Spine.Controller.create({
    events: {
      "click .item": "click"
    },
    
    proxied: ["change"],
    
    selectFirst: false,
    
    init: function(){
      this.bind("change", this.change);
    },
    
    template: function(){ return arguments[0] },
        
    change: function(item){
      if ( !item ) return;
      this.current = item;

      this.children().removeClass("active");
      this.children().forItem(this.current).addClass("active");
    },
        
    render: function(items){
      if (items) this.items = items;
      this.el.html(this.template(this.items));
      this.change(this.current);
      
      if ( this.selectFirst )
        if ( !this.children(".active").length || !this.current )
          this.children(":first").click();
    },
    
    children: function(sel){
      return this.el.children(sel);
    },
    
    click: function(e){
      var item = $(e.target).item();
      this.trigger("change", item);
    }
  });
  
})(Spine, Spine.$);};
}

sub spine_model_local {
q{Spine.Model.Local = {
  extended: function(){
    this.sync(this.proxy(this.saveLocal));
    this.fetch(this.proxy(this.loadLocal));
  },
    
  saveLocal: function(){
    var result = JSON.stringify(this);
    localStorage[this.name] = result;
  },

  loadLocal: function(){
    var result = localStorage[this.name];
    if ( !result ) return;
    var result = JSON.parse(result);
    this.refresh(result);
  }
};};
}

sub spine_tabs {
q{// Usage:

// <ul class="tabs">
//  <li data-name="users">Users</li>
//  <li data-name="groups">Groups</li>
// </ul>
// 

// var users = Users.init();
// var groups = Groups.init();
// Manager.init(users, groups);
//
// var tabs = Spine.Tabs.init({el: $(".tabs")});
// tabs.connect("users", users);
// tabs.connect("groups", groups);
//
// // Select first tab.
// tabs.render();

(function(Spine, $){
  
  Spine.Tabs = Spine.Controller.create({
    events: {
      "click [data-name]": "click"
    },
    
    proxied: ["change"],
    
    init: function(){
      this.bind("change", this.change);
    },
            
    change: function(name){
      if ( !name ) return;
      this.current = name;

      this.children().removeClass("active");
      this.children("[data-name='" + this.current + "']").addClass("active");
    },
        
    render: function(){
      this.change(this.current);
      if ( !this.children(".active").length || !this.current )
        this.children(":first").click();
    },
    
    children: function(sel){
      return this.el.children(sel);
    },
    
    click: function(e){
      var name = $(e.target).attr("data-name");
      this.trigger("change", name);
    },
    
    connect: function(tabName, controller) {
      this.bind("change", function(name){
        if (name == tabName)
          controller.active();
      });
    }
  });
  
})(Spine, Spine.$);};
}

sub spine_manager {
q{////
// A Manager is basically a state machine that controls a set of controller's 'active' state.
// In other words, you feed a manager controllers, and it'll make sure that only controller has an 'active' state at any one time. 
// This is useful whenever you're implementing tabs or separate views inside an application. 
//
// By default, whenever a controller is activated, it's element receives a 'active' class, and whenever it's deactivated it has a 'deactive' class. // You can use these classes to show/hide views and tabs via CSS.
// For example:
//
//  var users = Users.init();
//  var groups = Groups.init();
//  Manager.init(users, groups);
//  
//  users.active();
//  assert( users.isActive() );
//  assert( users.el.hasClass("active") );
//  assert( groups.el.hasClass("deactive") );
//  
//  groups.active();
//  assert( groups.el.hasClass("active") );
//  assert( users.el.hasClass("deactive") );

(function(Spine, $){

var Manager = Spine.Manager = Spine.Class.create();
Manager.include(Spine.Events);

Manager.include({
  init: function(){
    this.add.apply(this, arguments);
  },
  
  add: function(controller){
    if (arguments.length > 1) {
      var args = Spine.makeArray(arguments);
      for (var i=0; i < args.length; i++) this.add(args[i]);
      return;      
    }
    
    if ( !controller ) throw("Controller required");
    
    this.bind("change", function(current){
      if (controller == current)
        controller.activate();
      else
        controller.deactivate();
    });
    
    controller.active(this.proxy(function(){
      this.trigger("change", controller);
    }));
  } 
});

Spine.Controller.include({
  active: function(callback){
    if (typeof callback == "function") 
      this.bind("active", callback) 
    else {
      var args = Spine.makeArray(arguments);
      args.unshift("active");
      this.trigger.apply(this, args);
    }
    return this;
  },
  
  isActive: function(){
    return this.el.hasClass("active");
  },
  
  activate: function(){
    this.el.addClass("active");
    return this;
  },
  
  deactivate: function(){
    this.el.removeClass("active");
    return this;
  }
});

})(Spine, Spine.$);};
}

sub spine_route {
q{// Spine routing, based on Backbone's implementation.
//  Backbone.js 0.3.3
//  (c) 2010 Jeremy Ashkenas, DocumentCloud Inc.
//  Backbone may be freely distributed under the MIT license.
//  For all details and documentation:
//  http://documentcloud.github.com/backbone
//
// For usage, see examples/route.html

(function(Spine, $){  
  var Route = Spine.Route = Spine.Class.create();
  
  var hashStrip = /^#*/;
  
  Route.extend({
    routes: [],
    
    historySupport: ("history" in window),
    history: false,
        
    add: function(path, callback){
      if (typeof path == "object")
        for(var p in path) this.add(p, path[p]);
      else
        this.routes.push(this.init(path, callback));
    },
    
    setup: function(options){
      if (options && options.history)
        this.history = this.historySupport && options.history;
        
      if ( this.history )
        $(window).bind("popstate", this.change);
      else
        $(window).bind("hashchange", this.change);
      this.change();
    },
    
    unbind: function(){
      if (this.history)
        $(window).unbind("popstate", this.change);
      else
        $(window).unbind("hashchange", this.change);
    },
    
    navigate: function(){
      var args = Spine.makeArray(arguments);
      var triggerRoutes = true;
      
      if (typeof args[args.length - 1] == "boolean") {
        triggerRoutes = args.pop();
      }
      
      var path = args.join("/");      
      if (this.path == path) return;
      
      if ( !triggerRoutes )
        this.path = path;
      
      if (this.history)
        history.pushState({}, 
          document.title, 
          this.getHost() + path
        );
      else
        window.location.hash = path;
    },
    
    // Private
    
    getPath: function(){
      return window.location.pathname;
    },
    
    getHash: function(){
      return window.location.hash;
    },
    
    getHost: function(){
      return((document.location + "").replace(
        this.getPath() + this.getHash(), ""
      ));
    },
    
    getFragment: function(){
      return this.getHash().replace(hashStrip, "");
    },
    
    change: function(e){
      var path = (this.history ? this.getPath() : this.getFragment());
      if (path == this.path) return;
      this.path = path;
      for (var i=0; i < this.routes.length; i++)
        if (this.routes[i].match(path)) return;
    }
  });
  
  Route.proxyAll("change");
  
  var namedParam   = /:([\w\d]+)/g;
  var splatParam   = /\*([\w\d]+)/g;
  var escapeRegExp = /[-[\]{}()+?.,\\^$|#\s]/g;

  Route.include({    
    init: function(path, callback){
      this.callback = callback;
      if (typeof path == "string") {      
        path = path.replace(escapeRegExp, "\\$&")
                   .replace(namedParam, "([^\/]*)")
                   .replace(splatParam, "(.*?)");
                       
        this.route = new RegExp('^' + path + '$');
      } else {
        this.route = path;
      }
    },
    
    match: function(path){
      var match = this.route.exec(path)
      if ( !match ) return false;
      var params = match.slice(1);
      this.callback.apply(this.callback, params);
      return true;
    }
  });
  
  Spine.Controller.fn.route = function(path, callback){
    Spine.Route.add(path, this.proxy(callback));
  };
  
  Spine.Controller.fn.routes = function(routes){
    for(var path in routes)
      this.route(path, routes[path]);
  };
  
  Spine.Controller.fn.navigate = function(){
    Spine.Route.navigate.apply(Spine.Route, arguments);
  };
})(Spine, Spine.$);};
}

sub spine_tmpl {
q{// jQuery.tmpl.js utilities

(function($){

$.fn.item = function(){
  var item = $(this).tmplItem().data;
  return($.isFunction(item.reload) ? item.reload() : null);
};

$.fn.forItem = function(item){
  return this.filter(function(){
    var compare = $(this).tmplItem().data;
    if (item.eql && item.eql(compare) || item === compare)
      return true;
  });
};

})(jQuery);};
}

sub spine_model_ajax {
q{(function(Spine, $){
  
var Model = Spine.Model;

var getUrl = function(object){
  if (!(object && object.url)) return null;
  return((typeof object.url == "function") ? object.url() : object.url);
};

var methodMap = {
  "create":  "POST",
  "update":  "PUT",
  "destroy": "DELETE",
  "read":    "GET"
};

var urlError = function() {
  throw new Error("A 'url' property or function must be specified");
};

var ajaxSync = function(record, method, data){
  if (Model._noSync) return;
  
  var params = {
    type:          methodMap[method],
    contentType:  "application/json",
    dataType:     "json",
    data:         data,
  };
    
  if (method == "create" && record.model)
    params.url = getUrl(record.parent);
  else
    params.url = getUrl(record);

  if (!params.url) throw("Invalid URL");
    
  if (method == "create" || method == "update") {
    var data = {};
    
    if (Model.ajaxPrefix) {
      var prefix = record.parent.name.toLowerCase();
      data = {};
      data[prefix] = record;
    } else {
      data = record;
    }
    data = $.extend(data, params.data);
    params.data = JSON.stringify(data);
    params.processData = false;
  }
  
  if (method == "read" && !params.success)
    params.success = function(data){
     (record.refresh || record.load).call(record, data);
    };
  
  params.error = function(xhr, s, e){
    record.trigger("ajaxError", xhr, s, e);
  };
  
  $.ajax(params);
};

Model.Ajax = {
  extended: function(){    
    this.sync(ajaxSync);
    this.fetch(this.proxy(function(params){
      ajaxSync(this, "read", params);
    }));
  }
};

Model.extend({
  ajaxPrefix: false,
  
  url: function() {
    return "/" + this.name.toLowerCase() + "s"
  },
  
  noSync: function(callback){
    Model._noSync = true;
    callback.apply(callback, arguments);
    Model._noSync = false;
  }
});

Model.include({
  url: function(){
    var base = getUrl(this.parent);
    base += (base.charAt(base.length - 1) == "/" ? "" : "/");
    base += encodeURIComponent(this.id);
    return base;        
  }  
});

})(Spine, Spine.$);};
}

sub spine_route_shim {
q{var Spine = require("spine");

var Route = Spine.Route = Spine.Class.create();
Route.extend(Spine.Events);

Route.extend({
  routes: [],

  add: function(path, callback){
    if (typeof path == "object")
      for(var p in path) this.add(p, path[p]);
    else
      this.routes.push(this.init(path, callback));
  },
  
  setup: function(options){
    this.bind("change", this.change);
  },
  
  unbind: function(){},
  
  navigate: function(){
    var args = Spine.makeArray(arguments);
    var triggerRoutes = true;
    
    if (typeof args[args.length - 1] == "boolean") {
      triggerRoutes = args.pop();
    }
    
    var path = args.join("/");      
    if (this.path == path) return;
    
    if ( !triggerRoutes )
      this.path = path;
    
    this.trigger("change", path);
  },
  
  // Private
  
  change: function(path){
    if (path == this.path) return;
    this.path = path;
    for (var i=0; i < this.routes.length; i++)
      if (this.routes[i].match(path)) return;
  }
});
  
var namedParam   = /:([\w\d]+)/g;
var splatParam   = /\*([\w\d]+)/g;
var escapeRegExp = /[-[\]{}()+?.,\\^$|#\s]/g;

Route.include({    
  init: function(path, callback){
    this.callback = callback;
    if (typeof path == "string") {      
      path = path.replace(escapeRegExp, "\\$&")
                 .replace(namedParam, "([^\/]*)")
                 .replace(splatParam, "(.*?)");
                     
      this.route = new RegExp('^' + path + '$');
    } else {
      this.route = path;
    }
  },
  
  match: function(path){
    var match = this.route.exec(path)
    if ( !match ) return false;
    var params = match.slice(1);
    this.callback.apply(this.callback, params);
    return true;
  }
});

Spine.Controller.fn.route = function(path, callback){
  Spine.Route.add(path, this.proxy(callback));
};

Spine.Controller.fn.routes = function(routes){
  for(var path in routes)
    this.route(path, routes[path]);
};

Spine.Controller.fn.navigate = function(){
  Spine.Route.navigate.apply(Spine.Route, arguments);
};};
}

1;
__END__

=encoding utf8

=head1 NAME

Amon2::Setup::Asset::Spine -

=head1 SYNOPSIS

  use Amon2::Setup::Asset::Spine;

=head1 DESCRIPTION

Amon2::Setup::Asset::Spine is

=head1 AUTHOR

Kazuhiro Shibuya E<lt>stevenlabs at gmail dot comE<gt>

=head1 SEE ALSO

=head1 LICENSE

Copyright (C) Kazuhiro Shibuya

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
