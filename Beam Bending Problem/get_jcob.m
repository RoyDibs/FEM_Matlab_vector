function [ELEM] = get_jcob(FE,ELEM,NODE,ielem)

elem = ELEM(ielem);
ngp = size(FE.N,2);

xe = zeros(length(elem.nodes),3);
for inod=1:length(elem.nodes)
    xe(inod,:) = NODE(elem.nodes(inod)).X;
end

elem.volume = polyarea(xe(:,1)',xe(:,2)',2);
jcob_sum = 0;

for igp=1:ngp
    xpsi = FE.dNdpsi(:,igp)'*xe(:,1);
    xeta = FE.dNdeta(:,igp)'*xe(:,1);
    ypsi = FE.dNdpsi(:,igp)'*xe(:,2);
    yeta = FE.dNdeta(:,igp)'*xe(:,2);

    elem.jcob(igp,1) = xpsi*yeta - ypsi*xeta;
    elem.xpsieta(igp,1:2) = [xpsi, xeta];
    elem.ypsieta(igp,1:2) = [ypsi,yeta];

    jcob_sum = jcob_sum + elem.jcob(igp,1);
end
ELEM(ielem) = elem;
if(abs(jcob_sum-elem.volume)>1e-10)
    fprintf('errChk: error in element jacobian\n');
end