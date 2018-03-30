-module(time_handler).

-export([
         init/2,
         content_types_provided/2
        ]).

-export([
         time_to_html/2,
         time_to_json/2,
         time_to_text/2
        ]).

init(Req, Opts) ->
    {cowboy_rest, Req, Opts}.

content_types_provided(Req, State) ->
    {[
        {<<"text/html">>, time_to_html},
        {<<"application/json">>, time_to_json},
        {<<"text/plain">>, time_to_text}
    ], Req, State}.

time_to_html(Req, State) ->
    {Hour, Minute, Second} = erlang:time(),
    {Year, Month, Day} = erlang:date(),
    Body = "<html>
<head>
    <meta charset=\"utf-8\">
    <title>REST Time</title>
</head>
<body>
    <h1>REST time server</h1>
    <ul>
        <li>Time -- ~2..0B:~2..0B:~2..0B</li>
        <li>Date -- ~4..0B/~2..0B/~2..0B</li>
</body>
</html>",
    Body1 = io_lib:format(Body, [
        Hour, Minute, Second,
        Year, Month, Day
    ]),
    Body2 = list_to_binary(Body1),
    {Body2, Req, State}.

time_to_json(Req, State) ->
    {Hour, Minute, Second} = erlang:time(),
    {Year, Month, Day} = erlang:date(),
    Body = "
{
    \"time\": \"~2..0B:~2..0B:~2..0B\",
    \"date\": \"~4..0B/~2..0B/~2..0B\"
}",
    Body1 = io_lib:format(Body, [
        Hour, Minute, Second,
        Year, Month, Day
    ]),
    Body2 = list_to_binary(Body1),
    {Body2, Req, State}.

time_to_text(Req, State) ->
    {Hour, Minute, Second} = erlang:time(),
    {Year, Month, Day} = erlang:date(),
    Body = "
    time: ~2..0B:~2..0B:~2..0B,
    date: ~4..0B/~2..0B/~2..0B
",
    Body1 = io_lib:format(Body, [
        Hour, Minute, Second,
        Year, Month, Day
    ]),
    Body2 = list_to_binary(Body1),
    {Body2, Req, State}.