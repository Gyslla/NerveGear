function [ ERRO ] = cfs2cam3gy( RODADA )

ERRO='1';
DATA=RODADA ;  

cfs2cam_analisegy(DATA);
cfs2cam_sstgy(DATA);

ERRO='0';
f2 = fopen('./done', 'w');
end
