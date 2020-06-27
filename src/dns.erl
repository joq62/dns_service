%%% -------------------------------------------------------------------
%%% @author : joqerlang
%%% @doc : ets dbase for master service to manage app info , catalog  
%%%
%%% -------------------------------------------------------------------
-module(dns).
 


%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

%-compile(export_all).
-export([all/1,get/2,update/0,add/3,delete/3,
	update_local_dns/1]).




%% ====================================================================
%% External functions
%% ====================================================================
update_local_dns(DnsInfo)->
    ActiveBootServices=get("boot_services",DnsInfo),
    [rpc:cast(Node,boot_service,dns_update,[DnsInfo])||{_,Node}<-ActiveBootServices],
    ok.


%% --------------------------------------------------------------------
%% 
%% 
%% {"master_sthlm_1",'master_sthlm_1@asus'}
%% --------------------------------------------------------------------
%% @doc: get(ServiceId) returns of a list of nodes that have ServiceId all running applications

-spec(all(DnsInfo::[{ServiceId::string(),Node::atom()}])->[{ServiceId::string(),Node::atom()}]|[]).
all(DnsInfo)->
    DnsInfo.


%% @doc: get(ServiceId) returns of a list of nodes that have ServiceId all running applications
-spec(get(ServiceId::string(),DnsInfo::[{ServiceId::string(),Node::atom()}])->[{ServiceId::string(),Node::atom()}]|[]).
get(WantedServiceId,DnsInfo)->
    ActiveServices=[{ServiceId,Node}||{ServiceId,Node}<-DnsInfo,
				      WantedServiceId==ServiceId],
    ActiveServices.

%% @doc: update(Catalog) update the dns list

-spec(update()->[{ServiceId::string(),Node::atom()}]| []).
update()->
    Nodes=[node()|nodes()],
    L1=[{rpc:call(Node,application,which_applications,[]),Node}||Node<-Nodes],
    ServiceList=lists:append([create_list(AppInfo,Node,[])||{AppInfo,Node}<-L1]),
    ServiceList.


create_list([],_Node,ServiceList)->
    ServiceList;
create_list([{Service,_Desc,_Vsn}|T],Node,Acc)->
    NewAcc=[{atom_to_list(Service),Node}|Acc],
    create_list(T,Node,NewAcc).


%% @doc: add(ServiceId,Node,DnsInfo) -> New DnsInfo list

-spec(add(ServiceId::string(),Node::atom(),DnsInfo::[tuple()])->DnsInfo::[tuple()]|[]).
add(ServiceId,Node,DnsInfo)->
    Removed=[{S1,N1}||{S1,N1}<-DnsInfo,
		      {ServiceId,Node}/={S1,N1}],
    NewDnsInfo=[{ServiceId,Node}|Removed],
    {ok,NewDnsInfo}.


%% @doc:delete(ServiceId,Node,DnsInfo) -> New DnsInfo list

-spec(delete(ServiceId::string(),Node::atom(),DnsInfo::[tuple()])->DnsInfo::[tuple()]|[]).
delete(ServiceId,Node,DnsInfo)->
    NewDnsInfo=[{S1,N1}||{S1,N1}<-DnsInfo,
		      {ServiceId,Node}/={S1,N1}],
    {ok,NewDnsInfo}.
