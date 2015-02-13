function end_index = end(e,k,n)
%END Last index in an indexing expression for an emg_set.
%   END(A,K,N) is called for indexing expressions involving the emg_set
%   E when END is part of the K-th index out of N indices.  For example, the
%   expression E(end-1,:) calls E's END method with END(E,1,2).

switch k
    case 1
        end_index = size(e.data, 1);
    case 2
        end_index = size(e.data, 2);
    otherwise
        end_index = 1;
end
