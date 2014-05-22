function ChannelData = getChannelData(Data, HDR, ChannelName)
    Idx = strcmp(ChannelName, HDR.Label);
    ChannelIdx = find(Idx);
    
    ChannelData = Data(:,ChannelIdx);
end