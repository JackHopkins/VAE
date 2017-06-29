local Maskh, parent = torch.class('nn.Maskh', 'nn.Module')

function Maskh:__init()
   parent.__init(self)
   self.gradInput = {}
end

function Maskh:updateOutput(input)
   local prev, current, mask = unpack(input)
   assert(prev:size(1) == mask:size(1))
   local mask_ = mask:clone()
   mask_ = mask_:view(mask_:size(1),-1):expandAs(prev)

   --Force long tensor into double
   mask_double = torch.DoubleTensor()
   mask_double:resize(mask_:size()):copy(mask_) 


   self.output = torch.cmul(prev, -mask_double+1) + torch.cmul(current, mask_double)
   return self.output
end

function Maskh:updateGradInput(input, gradOutput)
   local prev, current, mask = unpack(input)
   assert(prev:size(1) == mask:size(1))
   local mask_ = mask:clone()
   mask_ = mask_:view(mask_:size(1),-1):expandAs(prev)

   --Force long tensor into double
   mask_double = torch.DoubleTensor()
   mask_double:resize(mask_:size()):copy(mask_) 

   self.gradInput[1] = self.gradInput[1] or prev.new()
   self.gradInput[1]:resizeAs(prev)
   self.gradInput[2] = self.gradInput[2] or current.new()
   self.gradInput[2]:resizeAs(current)
   self.gradInput[1]:copy(torch.cmul(gradOutput, -mask_double+1))
   self.gradInput[2]:copy(torch.cmul(gradOutput, mask_double))
   self.gradInput[3] = torch.zeros(mask:size())
   return self.gradInput
end


