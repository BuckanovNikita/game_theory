function [consignment consignment_times] = TakeFromStock(consignment, consignment_times, taking )

index = 1;
while ((taking > 0)&&(index <= length(consignment)))
    if (taking >= consignment(index))
        consignment(index) = consignment(index) - taking;
        taking = 0;
    else
        taking = taking - consignment(index);
        consignment(index) = 0;
        index = index + 1;
    end
end

end

