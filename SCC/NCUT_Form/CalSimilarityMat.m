function W=CalSimilarityMat(data,sigma)
    % CalSimilarityMat �˴���ʾ�йش˺�����ժҪ
    % data��������ڽ�/���ƾ���
    % type������������˹����ķ���or��ĳЩ�㷨�е�ʵ����ʽ
    % L����ֵ��������˹����
%     W=exp(-(dist(data,data').^2)/(2*(sigma)^2));  
%     M = exp(-M.^2 ./ (2*sigma^2));
%% ��������out of memory
    W = squareform(pdist(data));
    W = exp(-W.^2 ./ (2*sigma^2));
%% ŷ�Ͼ���������д�����������´˴���Ȼout of memory
%     W = sqrt(bsxfun(@plus,sum(data.^2,2),sum(data.^2,2)') - 2*(data*data') );
%     W = exp(-W.^2 ./ (2*sigma^2));
%%
%     for i=1:length(data)
%         for j=1:length(data)
%             Wtest(i,j)=exp(-(dist(data(i,:),data(j,:)').^2)/(2*(sigma)^2));  
%         end
%     end
%% ̫��
% dataLength=length(data);
%         for i=1:dataLength
%             for j=1:dataLength
%                   W(i,j)=(data(i,:)-data(j,:))*(data(i,:)-data(j,:))';
%                     costMat(i,j)=(pdist2(u(i,:),data(j,:),'euclidean'))^2;
%             end
%         end
%         W;
end

