defmodule Chucky do
  use Application
  require Logger

  def start(type, _args) do
    import Supervisor.Spec

    case type do
      :normal ->
        Logger.info "Application start on node #{node()}"
      {:takeover, old_node} ->
        Logger.info "#{node()} is taking over #{old_node}"
      {:failover, old_node} ->
        Logger.info "#{node()} is failing over to #{old_node}"
    end

    children = [ worker(Chucky.Server, []) ]
    opts = [strategy: :one_for_one, name: {:global, Chucky.Supervisor}]
    Supervisor.start_link(children, opts)
  end

  def fact do
    Chucky.Server.fact
  end

end
