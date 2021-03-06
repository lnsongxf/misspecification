function [ llk ] = KF_wrap_single_model( params,setup,data,mm )


if setup.initial_provided==1


wrapper_func=str2func(setup.wrapper{mm});
[A B C D add_matrices]=wrapper_func([params(setup.index_model{1});params(setup.index_model{mm+1})],setup,data{mm});

if setup.TVKF==1
    [ llk xest] = TVKF(A,B,C,D,setup.state_initial{mm},setup.cov_initial{mm},data{mm});
else
[ llk xest] = KF(A,B,C,D,setup.state_initial{mm},setup.cov_initial{mm},data{mm});
end




else

wrapper_func=str2func(setup.wrapper{mm});
[A B C D initial_state initial_cov add_matrices]=wrapper_func([params(setup.index_model{1});params(setup.index_model{mm+1})],setup,data{mm});;
if setup.TVKF==1
[ llk xest] = TVKF(A,B,C,D,initial_state ,initial_cov,data{mm});
else
[ llk xest] = KF(A,B,C,D,initial_state,initial_cov,data{mm});
end
    





end

xest=[];
add_matrices=[]; %keep those empty for now. Change this later if we want to store estimates states or something else
