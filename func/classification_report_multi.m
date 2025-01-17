function r = classification_report_multi(labels,preds,varargin)

classes = unique(labels);

tp = zeros(length(classes),1);
tn = zeros(length(classes),1);
fp = zeros(length(classes),1);
fn = zeros(length(classes),1);
precision = zeros(length(classes),1);
recall = zeros(length(classes),1);
acc = zeros(length(classes),1);
f1 = zeros(length(classes),1);
mcc = zeros(length(classes),1);

for class = 1:length(classes)

    labels_class = double(labels == class);
    preds_class = double(preds == class);

    for m = 1:length(preds_class)
        if preds_class(m) == labels_class(m)
            if preds_class(m) == 1
                tp(class) = tp(class) + 1;
            elseif preds_class(m) == 0
                tn(class) = tn(class) + 1;
            end
        else
            if preds_class(m) == 1
                fp(class) = fp(class) + 1;
            elseif preds_class(m) == 0
                fn(class) = fn(class) + 1;
            end
        end
    end

    precision(class) = tp(class)/(tp(class)+fp(class));
    recall(class) = tp(class)/(tp(class)+fn(class));

    acc(class) = (tp(class)+tn(class))./(tp(class)+tn(class)+fp(class)+fn(class));
    f1(class) = 2*(precision(class)*recall(class))./(precision(class)+recall(class));
    mcc(class) = (tp(class)*tn(class)-fp(class)*fn(class))/sqrt((tp(class)+fp(class))*(tp(class)+fn(class))*(tn(class)+fp(class))*(tn(class)+fn(class)));

end

T = table(classes,acc,mcc,f1,precision,recall,tp,tn,fp,fn);
T.Properties.VariableNames = {'class','acc','mcc','f1','precision','recall','TP','TN','FP','FN'};
disp(T)

C = confusionmat(labels,preds);
if ~isempty(varargin)
    if strcmpi(varargin{1},'showconfusion')
        confusionchart(C);
    end
end

r.acc = acc;
r.mcc = mcc;
r.f1 = f1;
r.precision = precision;
r.recall = recall;
r.tp = tp;
r.tn = tn;
r.fp = fp;
r.fn = fn;
r.confusion = C;