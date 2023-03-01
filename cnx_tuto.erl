-module(cnx_tuto).
-autor("BG").

% Api

-export([start/0]).
-define(Port, 4000).

%inicio

start() ->
       
      
    Pid = spawn_link(fun() ->
        {ok, LSocket} = gen_tcp:listen(?Port, [binary, {active, true}]),
            spawn(fun() -> acceptState(LSocket) end),
            timer:sleep(infinity) end),
        {ok, Pid}.

acceptState(LSocket) ->

        {ok, ASocket} = gen_tcp:accept(LSocket),
            spawn(fun() -> acceptState(LSocket) end),
            handler(ASocket).

handler(ASocket) ->

        inet:setopts(ASocket, [{active, once}]),
            
            receive 

                {tcp, ASocket, <<"quit">>} ->
                    gen_tcp:send(ASocket, "Cerrado"),
                    gen_tcp:close(ASocket);

                {tcp, ASocket, <<"value=", X/binary>>} ->
                    Val = list_to_integer(binary_to_list(X)),

                    Return = Val * Val,

                    gen_tcp:send(ASocket, "Result: "++list_to_binary(integer_to_list(Return))),
                    handler(ASocket);
        
                {tcp, ASocket, BinMsg} ->

                    if(BinMsg =:= <<"Grimoire">>) ->

                        gen_tcp:send(ASocket, "Mandando mensaje");

                      (BinMsg =:= <<"ls">>) ->

                        gen_tcp:send(ASocket, "ls()");


                    true ->
                        gen_tcp:send(ASocket, "Mandaste otra cosa")

                    end,

                handler(ASocket)
            end.