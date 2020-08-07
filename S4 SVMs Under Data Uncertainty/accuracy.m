
function acc = accuracy(targ, pred)
   if length(targ) ~= length(pred)
       error("Input dimensions do not match.")
   end
   acc = sum(targ==pred)/length(targ);
end