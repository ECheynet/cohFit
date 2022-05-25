function fth = label(titlestring,xpos,ypos,varargin)

% xpos and ypos are normalized values between  0 and 1

%% Inputparseer
p = inputParser();
p.CaseSensitive = false;
p.addOptional('alignement','left');
p.addOptional('Color','black');
p.addOptional('verticalalignment','bottom');
p.addOptional('fontsize',12);
p.addOptional('unit','normalized');
p.parse(varargin{:});
%%%%%%%%%%%%%%%%%%%%%%%%%%
fontsize = p.Results.fontsize ; 
col = p.Results.Color ; 
alignement = p.Results.alignement;
verticalalignment= p.Results.verticalalignment;
unit= p.Results.unit;
%%

fth = text(xpos,ypos,titlestring,'units',unit,'horizontalalignment',alignement,...
    'verticalalignment',verticalalignment,'fontsize',fontsize,'Color',col);

set(gcf,'CurrentAxes',gca,'name',titlestring);
set(fth,'interpreter','latex');
end
