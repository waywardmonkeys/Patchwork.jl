abstract Writer

immutable MinifiedHTML5 <: Writer end
immutable PrettyHTML5 <: Writer end
immutable MinifiedXML <: Writer end
immutable PrettyXML <: Writer end

function tohtml(t)
    buf = IOBuffer()
    writehtml(buf, t)
    takebuf_string(buf)
end

# Write HTML
writehtml(io::IO, t::PCDATA) =
    write(io, t.value)

writehtml{ns, name}(io::IO, a::Attr{ns, name}) =
    write(io, " ", name, "=\"", string(a.value), "\"")

#function writehtml(io::IO, doc::Document)
#    write(io, doc.doctype, "\n")
#    writehtml(io, elem(:html, ElemList(doc.head, doc.body)))
#end

function writehtml{ns, tag}(io::IO, el::Parent{ns, tag})
    write(io, "<", tag)
    for a in el.attributes
        writehtml(io, a)
    end
    write(io, ">")
    writehtml(io, el.children)
    write(io, "</", tag, ">")
end

function writehtml{ns, tag}(io::IO, el::Leaf{ns, tag})
    write(io, "<", tag)
    for a in el.attributes
        writehtml(io, a)
    end
    write(io, "/>")
end

function writehtml(io::IO, el::NodeVector)
    for n in el
        writehtml(io, n)
    end
end

writemime(io::IO, m::MIME"text/html", x::Node) =
    writehtml(io, x)