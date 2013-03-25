{dispatch_impl} = require 'libprotocol'
{info, warn, error, debug} = dispatch_impl 'ILogger', 'IDom'

$ = require 'commonjs-jquery'

IDom = [
    ['html',          ['new_content']]
    ['setValue',      ['new_value']]
    ['setText',       ['new_text']]
    ['getValue',      []]
    ['alert',         ['msg']]
    ['click',         ['handler']]
    ['globalclick',   ['handler']]
    ['keyDown',       ['handler']]
    ['globalKeyDown',       ['handler']]
    ['on_change',     ['handler']]

    ['appendContent', ['content']]
    ['kill',          []]
    ['stop_event',    ['e']]
    ['setAttr',       ['attr']]
    ['dbclick',       ['e']]
    ['focusout',      ['e']]
    ['focus',         []]
    ['get_by_attr',   ['attr']]
    ['get_by_id',     ['id']]
    ['getData',       ['attr', 'node']]
    ['get_id',        ['node']]
    ['on_dom_ready',  ['f']]
    ['one',           ['sel']]
    ['document',      []]
    ['get_root_node', []]
    ['add_event_listener', ['event_name', 'handler']]
    ['on_document_loaded', ['f']]

    ['toggleClass', ['from_to']]

    ['data',    []]
    ['target',  ['ev']]

    ['is_in',      ['subtree', 'ev']]

    ['parent', []]

    ['disable', []]
    ['enable', []]

    ['text!', ['text']]

]

in_subtree = ($node, target) ->
    if !!$node.find(target).length or ($node.is target)
        true
    else
        false

jqidom = (node) ->
    $node = $ node


    {
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

    html: (args...) ->
        $node.html (args.join '')

    setValue: (args...) ->
        $node.val (args.join '')

    setText: (args...) ->
        $node.text (args.join '')

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

    globalKeyDown: (handler) -> $(document).bind 'keydown', handler

    on_change: (handler) ->
        $node.bind 'onchange', handler

    dbclick: (handler) ->
        $node.dblclick handler

    focusout: (handler) ->
        $node.blur handler

    focus: ->
        $node.focus()

    get_by_attr: (attr) ->
        # FIXME
        r1 = try
            if ($node.is attr) then [$node] else []
        catch e
            []

        r1.concat ($node.find attr).toArray()

    get_by_id: (id) -> $ "##{id}"

    getData: (attr, node=$node) -> ($ node).data()[attr]

    get_id: (node=$node) -> ($ node).attr 'id'

    on_dom_ready: (f) ->  ($ document).ready f

    on_document_loaded: (f) ->  ($ window).load f

    one: (sel) -> ($ sel)

    document: -> window.document

    get_root_node: -> node

    add_event_listener: (event_name, handler) ->
        node.addEventListener event_name, handler



    toggleClass: ([from, to]) ->
        if $node.hasClass from
            $node.removeClass from
            $node.addClass to
        else
            $node.removeClass to
            $node.addClass from

    }

module.exports =
    protocols:
        definitions:
            IDom: IDom
        implementations:
            IDom: jqidom
