classdef CircularBuffer
    properties
        Buffer
        MaxSize
        CurrentIndex = 0
    end
    
    methods
        function obj = CircularBuffer(size, dataType)
            obj.MaxSize = size;
            obj.Buffer = nan(size, 1, dataType);
        end
        
        function obj = update(obj, newValue)
            obj.CurrentIndex = mod(obj.CurrentIndex, obj.MaxSize) + 1;
            obj.Buffer(obj.CurrentIndex) = newValue;
        end
        
        function buffer = getBuffer(obj)
            buffer = obj.Buffer;
        end
        
        function orderedBuffer = getOrderedBuffer(obj, startIndex)
            % Return the buffer starting from startIndex as the first element
            if startIndex < 1 || startIndex > obj.MaxSize
                error('Start index out of range');
            end
            orderedBuffer = [obj.Buffer(startIndex:end); obj.Buffer(1:startIndex-1)];
        end
    end
end
