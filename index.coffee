{dispatch_impl} = require 'libprotocol'
{info, warn, error, debug} = dispatch_impl 'ILogger', 'IDom'
{is_array} = require 'libprotein'

$ = require 'commonjs-jquery'

IDom = [
    ['set-html!',     ['new_content']]
    ['html',          ['new_content']]
    ['get-html',      []]
    ['setValue',      ['new_value']]
    ['setText',       ['text']]
    ['getValue',      []]
    ['alert',         ['msg']]
    ['click',         ['handler']]
    ['globalclick',   ['handler']]
    ['keyDown',       ['handler']]
    ['keyUp',         ['handler']]
    ['globalKeyDown', ['handler']]
    ['on_change',     ['handler']]
    ['change',        ['handler']]

    ['appendContent', ['content']]
    ['kill',          []]
    ['stop_event',    ['e']]
    ['setAttr',       ['attr']]
    ['dbclick',       ['e']]
    ['focusout',      ['e']]
    ['focus',         []]
    ['mouse_enter',   ['handler']]
    ['get_by_attr',   ['attr']]
    ['get_by_id',     ['id']]
    ['getData',       ['attr', 'node']]
    ['get_id',        ['node']]
    ['disable',       []]
    ['enable',        []]
    ['canWrite',      []]
    ['readonly',      []]
    ['on_dom_ready',  ['f']]
    ['one',           ['sel']]
    ['document',      []]
    ['get_root_node', []]
    ['add_event_listener', ['event_name', 'handler']]
    ['trigger',       ['event', 'args']]
    ['on_document_loaded', ['f']]

    ['addClass',      ['cls']]
    ['removeClass',   ['cls']]
    ['toggleClass',   ['from_to']]
    ['toggleText',    ['x', 'y']]

    ['data',    []]
    ['target',  ['ev']]

    ['is_in',      ['subtree', 'ev']]

    ['parent', []]

    ['text!', ['text']]

    ['append-to', ['sel']]

]

in_subtree = ($node, target) ->
    if !!$node.find(target).length or ($node.is target)
        true
    else
        false

jqidom = (node) ->
    $node = $ node


    {
    "append-to": (sel) -> $node.appendTo sel

    "text!": (t) -> $node.text t

    disable: -> $node.attr 'disabled', 'disabled'

    enable: -> $node.removeAttr 'disabled'

    data: -> $node.data()

    parent: -> $node.parent()

    target: (ev) -> ev.target

    is_in: (subtrees, target_node) ->
        for elid in subtrees
            $node = if elid is 'this'
                $node
            else
                $ "##{elid}"

            if in_subtree $node, target_node
                return true

        false

    'set-html!': (args...) ->
        $node.html (args.join '')

    html: (args...) ->
        $node.html (args.join '')

    'get-html': -> $node.html()

    setValue: (args...) ->
        $node.val (args.join '')

    setText: (text) -> $node.text text

    getValue: () ->
        # FIXME
        if ($node.prop 'tagName').toLowerCase() is 'span'
            $node.text()
        else
            $node.val()


    setAttr: (attr) ->
        say 'setattr'

    appendContent: (content) ->
        $node.append "<div>#{content}</div>"

    alert: (args...) -> alert args...

    click: (handler) -> $node.click handler

    globalclick: (handler) -> $(document).click handler

    kill: -> $node.remove()

    stop_event: (e) ->
        $.Event(e).stopPropagation()

    keyDown: (handler) -> $node.bind 'keydown', handler

    keyUp: (handler) -> $node.bind 'keyup', handler

    globalKeyDown: (handler) -> $(document).bind 'keydown', handler

    on_change: (handler) ->
        $node.bind 'onchange', handler

    change: (handler) -> $node.change handler

    dbclick: (handler) ->
        $node.dblclick handler

    focusout: (handler) ->
        $node.blur handler

    focus: ->
        $node.focus()

    mouse_enter: (handler) -> $node.mouseenter handler

    get_by_attr: (attr) ->
        # FIXME
        r1 = try
            if ($node.is attr) then [$node] else []
        catch e
            []

        r1.concat ($node.find attr).toArray()

    get_by_id: (id) -> $ "##{id}"

    getData: (attr, node=$node) -> 
        ($ node).data attr

    get_id: (node=$node) -> ($ node).attr 'id'

    on_dom_ready: (f) ->  ($ document).ready f

    on_document_loaded: (f) ->  ($ window).load f

    #get_id: (node=$node) -> (jQuery node).attr 'id'

    canWrite: -> $node.removeAttr 'readonly'

    readonly: -> $node.attr 'readonly', 'readonly'

    one: (sel) -> ($ sel)

    document: -> window.document

    get_root_node: -> node

    add_event_listener: (event_name, handler) ->
        if node.addEventListener
            node.addEventListener event_name, handler #, false?
        else if node.attachEvent # ie
            node.attachEvent "on#{event_name}", handler
        else
            error "Can't add event listener: no addEventListener nor attachEvent present", event_name, node
            throw "Can't add event listener: no addEventListener nor attachEvent present"

    trigger: (event, args) -> $node.trigger event, args

    addClass: (cls) -> $node.addClass cls

    removeClass: (cls) -> $node.removeClass cls

    toggleClass: ([from, to]) ->
        if $node.hasClass from
            $node.removeClass from
            $node.addClass to
        else
            $node.removeClass to
            $node.addClass from

    toggleText: (x, y) ->
        if x is $node.text() then $node.text y else $node.text x

    }

module.exports =
    protocols:
        definitions:
            IDom: IDom
        implementations:
            IDom: jqidom
