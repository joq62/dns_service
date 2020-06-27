%% This is the application resource file (.app file) for the 'base'
%% application.
{application, dns_service,
[{description, "dns_service" },
{vsn, "0.0.1" },
{modules, 
	  [dns_service_app,dns_service_sup,dns_service,
		dns]},
{registered,[dns_service]},
{applications, [kernel,stdlib]},
{mod, {dns_service_app,[]}},
{start_phases, []}
]}.
