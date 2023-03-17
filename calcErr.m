function [err] = calcErr(matconf)

diago_conf = diag(matconf);
suc = (sum(diago_conf) / sum(sum(matconf)));
err=(1-suc)*100;