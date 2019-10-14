function [ entropy ] = Entropy( gnd,result )
% ���ǵ�Entropy�����ǰ���class������cluster��������ģ���Ϊ����ֻҪ��������ground truth�ľ��໮�ֵĸ���
% ���Բ���Ҫ����k������class��Ŀ��������Ժ���Ҫ�ɸ��ģ�8-9�Ǽ���result��k���Ĵ���
    label=unique(gnd);
    nClass=length(label);               %nClass equals to nK
    sizeConsMat=hist(gnd,label);        %constrained coefficient
    
    labelClusters=unique(result);
    nK=length(labelClusters);
%     for i=1:nK
%         clusterSize(i)=length(find(result==i));
%     end
    
    
%     for i=1:nK
%         E_s_r(i)=
%     end
    
    i=1;
    base=1;
    p=[];
    
    count=[];
    for j=1:nClass
        count=[count;hist(result(base:(base+sizeConsMat(j)-1)),label)];
%         p=[p;count/clusterSize(i)];
        base=base+sizeConsMat(j);
        i=i+1;
    end
    clusterSize=sum(count);
    
    E_S_r=[];
    for i=1:nK
        tmp=count(:,i)./clusterSize(i); 
        E_S_r=[E_S_r,tmp.*log(tmp)];
    end
    E_S_r(isnan(E_S_r))=0;
    E_S_r=-(1/log(nClass))*sum(E_S_r);
    entropy=sum((clusterSize/length(result)).*E_S_r);
%     
%     %tmp=-(p.*log(p))'; ��δ��һ��
%     tmp=-(1/log(nClass))*(p.*log(p))'; %�ع�һ��
%     tmp(isnan(tmp))=0;
%     e=sum( tmp );
% %     e(isnan(e))=0;
%     m=sizeConsMat/sum(sizeConsMat);
%     entropy=sum(m.*e);
end

