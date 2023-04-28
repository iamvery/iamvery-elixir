Logger.configure(level: :info)
{:ok, _} = Test.Support.Endpoint.start_link()
ExUnit.start()
