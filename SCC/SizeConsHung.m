function [MSE_best,re]=SizeConsHung(data,k,u,sizeConsMat)
    MSE_best=inf;
    sumError=0;
    [dataLength,~]=size(data);
    slots=zeros(dataLength,2);
    clusterSize=fix(dataLength/k);
    l=1;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %ÿ�������������slots,�������ֲ�����
%         count=1;                          
%         for i=1:clusterSize:(clusterSize*k)
%             slots(i:(i+clusterSize-1),1)=count;
%             count=count+1;
%         end
%         %������������slots
%         for i=1:(dataLength-k*clusterSize)
%             slots(k*clusterSize+i,1)=i;
%         end
          startPosition=1;
          for i=1:k
              slots(startPosition:startPosition+sizeConsMat(i)-1,1)=i;
              startPosition=startPosition+sizeConsMat(i);
          end
          count=0;
    while 1
        l=l+1;
        preCentroids=u;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
        %����cost����,���������ͼ(��������)
    %     u=numberedData(preCentroids,:);
    %     u(:,1)=[];
%         costMat=zeros(k*clusterSize,dataLength);
%           costMat=zeros(dataLength);
        centroidsCount=1;
%         for i=1:clusterSize:clusterSize*k
        startPosition=1;
       for i=1:k
            for j=1:dataLength
                costMat(startPosition:startPosition+sizeConsMat(i)-1,j)=...,
                (pdist2(u(centroidsCount,:),data(j,:),'euclidean'))^2;
            end
            centroidsCount=centroidsCount+1;
            startPosition=startPosition+sizeConsMat(i);
        end
%         %��ȫcost���󣬼���������
%         centroidsCount=1;
%         for i=(clusterSize*k+1):dataLength
%             for j=1:dataLength
%                 costMat(i,j)=...,
%                 (pdist2(u(centroidsCount,:),data(j,:),'euclidean'))^2;
%             end
%             centroidsCount=centroidsCount+1;
%         end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %�����������㷨�õ����ƥ��
        [assignment,cost] = munkres(costMat);
        MSE = cost/dataLength;

        %�����ƥ����Ÿ�ֵ��slots�������data->slots�ķ��乤��
        slots(:,2)=assignment;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %����ƽ��ֵ,��������
        for i=1:k
            assignedDataNum=slots(find(slots(:,1)==i),:);
            assignedDataNum(:,1)=[];
            assignedData=data(assignedDataNum,:);
            u(i,:)=mean(assignedData);
        end
%      %         calculate MSE
%         assignment=assignment';
% ԭʼ���ݱ��
%         re=zeros(dataLength,1);
%         for i=1:dataLength
%             re(i)=slots(find(slots(:,2)==i),1);
%         end  
%         MSE=0;
%         for i = 1:dataLength
%             MSE = MSE + ((data(i,:)-u(re(i),:))*(data(i,:)-u(re(i),:))')/dataLength;
%         end
%        
        if (MSE<MSE_best)
            MSE_best = MSE;
        else
            break;
        end
        if norm(preCentroids-u)<0.0001  %���ϵ���ֱ��λ�ò��ٱ仯
           break;
        end
        
%         else
%             break;
%         end
        count=count+1;
%         if count>100
%             mException=MException('Error:CanNotConvergence',...
%             'can not convergence of hungarian');
%         throw(mException);
%         end
    end
    
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %ԭʼ���ݷ�����
    re=zeros(dataLength,1);
    for i=1:dataLength
        re(i)=slots(find(slots(:,2)==i),1);
    end   
end
% % k=7;
% MSE_ITERATOR_S=[];
% repeat_num=1;
% 
% %  load s1.dat
% %  X=s1;
% % load iris.dat
% % X=iris;
% % number of points
% % n = size(X,1);
% n=size(X,1);
% 
% 
% % minimum size of a cluster
% 
% minimum_size_of_a_cluster = floor(n/k);
% 
% 
% % dimensionality
% 
% d = size(X,2);
% 
% MSE_best = 0; % dummy value
% 
% number_of_iterations_distribution = zeros(100,1);
% 
% for repeats = 1:1      % 1:100
% 
% % initial centroids
% %���forѭ���������ǳ�ʼ��centroids��passΪ�۲��ڣ���������˼·�ǣ��ܹ�k��centroids
% %����Ҫѭ��k�Σ�jΪѭ��������Ҳ����ǰ����centroids������pass��Ϊ0�������whileѭ����
% %iΪ<=n�������������passΪ1�����ŵ�һ��forѭ�����ж��Ѿ�����centroids���Ƿ��뵱ǰ
% %���ѡ���centroids�к���ͬ������ͬ������passΪ0������������ѡ�񣬷�����ѡ�и�ֵ��
% %C����centroids����
% % for j = 1:k
% % pass = 0;
% % while pass == 0
% %     i = randi(n);
% %     pass = 1;
% %     for l = 1:j-1
% %        if X(i,:) == C(l,:) 
% %            pass = 0;
% %        end
% %     end
% % end
% % C(j,:) = X(i,:);
% % end
% C=u;
% 
% 
% partition = 0;                 % dummy value
% partition_previous = -1;       % dummy value
% partition_changed = 1;
% 
% kmeans_iteration_number = 0;
% 
% while ((partition_changed)&&(kmeans_iteration_number<100))% kmeans iterations
%     
% partition_previous = partition;
% 
% % kmeans assignment step
% 
% % setting cost matrix for Hungarian algorithm
% costMat = zeros(n);
% costMatTest = zeros(n);
% for i=1:n
%     for j = 1:n
%         costMat(i,j) = (X(j,:)-C(mod(i,k)+1,:))*(X(j,:)-C(mod(i,k)+1,:))';
%     end  
% end
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% rowStart=1;
% for i=1:k
%     for j=1:n
%         costMatTest(rowStart:rowStart+sizeConsMat(i)-1,j)=(X(j,:)-C(i,:))*(X(j,:)-C(i,:))';
%     end
%     rowStart=rowStart+sizeConsMat(i);
% end
% 
% % Execute Hungarian algorithm
% [assignment,cost] = munkres(costMat);
% [assignmentTest,costTest] = munkres(costMatTest);
% 
% % zero partitioning
% for i = 1:n
%     partition(i) = 0;
% end
% 
% % find current partitioning from hungarian algorithm result
% for i = 1:n 
%     if assignment(i) ~= 0
%             partition(assignment(i))=mod(i,k)+1;
%     end
% end
% 
% % kmeans update step
% 
% for j = 1:k
% C(j,:) = mean(X(find(partition==j),:));
% end
% 
% 
% kmeans_iteration_number = kmeans_iteration_number +1;
% 
% partition_changed = sum(partition~=partition_previous);
% MSE = 0;
% for i = 1:n
%     MSE = MSE + ((X(i,:)-C(partition(i),:))*(X(i,:)-C(partition(i),:))')/n;
% end
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% MSE_ITERATOR_S(kmeans_iteration_number)=MSE;
% repeat_num=repeat_num+1;
% end  % kmeans iterations
% 
% 
% 
% if (MSE<MSE_best)||(repeats==1)
%     MSE_best = MSE;
%     C_best = C;
%     partition_best = partition;
% end
% 
% MSE_repeats(repeats) = MSE;
% 
% number_of_iterations_distribution(kmeans_iteration_number) = number_of_iterations_distribution(kmeans_iteration_number)+1;
% 
% end % repeats
%     
% 
% % new notation
% 
% C = C_best;
% partition = partition_best;
% MSE = MSE_best;
% 
% mean_MSE_repeats = mean(MSE_repeats);
% std_MSE_repeats = std(MSE_repeats);