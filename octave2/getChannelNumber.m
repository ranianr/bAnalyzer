function ChannelNumber = getChannelNumber(HDR, ChannelName)
    Idx = strcmp(ChannelName, HDR.Label);
    ChannelNumber = find(Idx(2:15));
end