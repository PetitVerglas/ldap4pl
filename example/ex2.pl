:- module(ex2, []).

:- use_module(library(ldap4pl)).
:- use_module(library(ldap4pl_util)).

:- debug(ex2).

search :-
    ldap_initialize(LDAP, 'ldap://172.16.0.223:389'),
    debug(ex2, 'LDAP ~w', [LDAP]),
    ldap_set_option(LDAP, ldap_opt_protocol_version, 3),
    ldap_simple_bind_s(LDAP, 'cn=admin,dc=cf,dc=ericsson,dc=net', s3cret),
    ldap_search(LDAP,
        query(
            base('dc=cf,dc=ericsson,dc=net'),
            scope(ldap_scope_onelevel),
            filter('(objectClass=*)'),
%            attrs([objectClass, sambaDomainName]),
            attrsonly(false)
        ),
        MsgID),
    ldap_result(LDAP, MsgID, true, Result),
    debug(ex2, 'Result ~w', [Result]),
    ldap_parse_result(LDAP, Result, ldap_success, MatchedDN, ErrorMsg, Referrals, SCtrls, false),
    debug(ex2, 'MatchedDN ~w', [MatchedDN]),
    debug(ex2, 'ErrorMsg ~w', [ErrorMsg]),
    debug(ex2, 'Referrals ~w', [Referrals]),
    debug(ex2, 'SCtrls ~w', [SCtrls]),
    ldap_parse_search_result(LDAP, Result, List),
    print_term(List, []),
    ldap_msgfree(Result),
    ldap_unbind(LDAP).

auth :-
    ldap_simple_auth('ldap://172.16.0.223:389',
        'cn=admin,dc=cf,dc=ericsson,dc=net',
        s3cret).