defmodule Servy.BearController do

    alias Servy.Wildthings

    def index(conv) do

        %{ conv | status: 200, resp_body: "Da Bearz" }
    end

    def show(conv, %{"id" => id}) do
        bear = Wildthings.get_bear(id)
        %{ conv | status: 200, resp_body: "<h1> Bear #{bear.id}: #{bear.name}"}
    end

    def create(conv, %{"name" => name, "type" => type} = params) do
        %{ conv | status: 201, resp_body: "Created a #{conv.params["type"]} bear names #{conv.params["name"]}" }
    end

    def delete(conv, %{"id" => id}) do
        bear = Wildthings.get_bear(id)
        %{ conv | status: 200, resp_body: "Bear #{bear.id}: #{bear.name} deleted" }
    end
end