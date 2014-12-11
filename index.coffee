{dispatch_impl} = require 'libprotocol'
{info, warn, error, debug} = dispatch_impl 'ILogger', 'IDom'
{is_array, is_function} = require 'libprotein'

$ = require 'commonjs-jquery'

IDom = [
    ['set-html!',           ['new_content']]
    ['html',                ['new_content']]
    ['get-html',            []]
    ['setValue',            ['new_value']]
    ['setText',             ['text']]
    ['getValue',            []]
    ['alert',               ['msg']]
    ['click',               ['handler']]
    ['click-once',          ['handler']]
    ['globalclick',         ['handler']]
    ['keyDown',             ['handler']]
    ['keyUp',               ['handler']]
    ['globalKeyDown',       ['handler']]
    ['on_change',           ['handler']]
    ['change',              ['handler']]

    ['appendContent',       ['content']]
    ['kill',                []]
    ['kill-9',              []]
    ['stop_event',          ['e']]
    ['setAttr',             ['attr', 'value']]
    ['getAttr',             ['attr']]
    ['dbclick',             ['e']]
    ['focusout',            ['e']]
    ['focusin',             ['handler']]
    ['focus',               []]
    ['select',               []]
    ['mouse_enter',         ['handler']]
    ['mouseout',            ['handler']]
    ['get_by_attr',         ['attr']]
    ['get_by_id',           ['id']]
    ['getData',             ['attr', 'node']]
    ['get_id',              ['node']]
    ['disable',             []]
    ['enable',              []]
    ['canWrite',            []]
    ['readonly',            []]
    ['on_dom_ready',        ['f']]
    ['one',                 ['sel']]
    ['document',            []]
    ['get_root_node',       []]
    ['add_event_listener',  ['event_name', 'handler']]
    ['trigger',             ['event', 'args']]
    ['on_document_loaded',  ['f']]

    ['addClass',            ['cls']]
    ['removeClass',         ['cls']]
    ['toggleClass',         ['from_to']]
    ['toggleText',          ['x', 'y']]
    ['css',                 ['attr', 'value']]

    ['data',                []]
    ['data-key',            ['key'], {doc: "Returns key from data attrs"}]
    ['target',              ['ev']]
    ['current-target',      ['ev']]

    ['is_in',               ['subtree', 'ev']]

    ['parent',              []]

    ['text!',               ['text']]

    ['append-to',           ['to_sel', 'which_sel']]

    ['click!',              ['orig_ev']]

    ['get_form_data',       []]
    ['preventDefault',      ['ev']]
    ['prepend',             ['content']]

    ['click-delegate',      ['selector', 'handler']]
    ['hover-delegate',      ['selector', 'handler']]
    ['delegate',            ['action', 'selector', 'handler']]

    ['global-key',          ['keys', 'handler']]
    
    ['if-checked?',            []]
    ['if-unchecked?',          []]
    ['submit',          []]
    ['scrollToId',           ['id', 'delta', 'speed']]
    ['eq',                  ['x', 'y']]
]

in_subtree = ($node, target) ->
    if !!$node.find(target).length or ($node.is target)
        true
    else
        false

jqidom = (node) ->
    $node = $ node


    {
    'global-key': (key, h) ->
        keys = if is_array key then key else [key]
        $(document).bind 'keydown', (ev) ->
            if ev.which in keys
                h ev.which

    'click-delegate': (sel, handler) ->
        real_sel = if is_function sel then sel() else sel
        ($ real_sel).click handler

    'hover-delegate': (sel, handler) ->
        real_sel = if is_function sel then sel() else sel

        ($ real_sel).mouseenter handler

    delegate: (action, selector, handler) ->
        $(selector).on action, handler

    preventDefault: (ev) -> ev.preventDefault()

    get_form_data: -> $node.serializeObject()

    prepend: (content) -> $node.prepend content

    'click!': (orig_ev) -> $node.click()

    mouseout: (handler) -> $node.mouseleave handler

    "append-to": (to_sel, which_sel) -> ($ which_sel).appendTo to_sel

    "text!": (t) -> $node.text t

    disable: -> $node.attr 'disabled', 'disabled'

    enable: -> $node.removeAttr 'disabled'

    data: -> $node.data()

    'data-key': (key) -> $node.data key

    parent: -> $node.parent()

    target: (ev) -> ev.target

    'current-target': (ev) -> ev.currentTarget

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


    setAttr: (attr, value) ->
        $node.attr attr, value
    
    getAttr: (name) -> $node.attr name
    
    appendContent: (content) ->
        $node.append "<div>#{content}</div>"

    alert: (args...) -> alert args...

    click: (handler) -> $node.click handler

    'click-once': (handler) -> $node.one 'click', handler

    globalclick: (handler) -> $(document).click handler

    kill: -> $node.remove()

    'kill-9': ->
        dna = require 'dna-lang'
        dna.forget_cell node.id
        $node.remove()

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

    focusin: (handler) ->
        $node.focus handler

    focus: ->
        $node.focus()
    
    select: -> $node.select()

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

    'if-checked?': ->
        if ($node.attr 'checked') is 'checked' then true else null

    'if-unchecked?': ->
        if ($node.attr 'checked') isnt 'checked' then true else null

    css: (attr, value) ->
        $node.css(attr, value)

    submit: () ->
        $node.submit()
    
    scrollToId: (id, delta, speed) -> 
        $('html, body').animate({scrollTop:$("##{id}").offset().top - delta}, speed);
    
    }
    
    eq: (x, y) ->
        x == y or null
    }

module.exports =
    protocols:
        definitions:
            IDom: IDom
        implementations:
            IDom: jqidom
