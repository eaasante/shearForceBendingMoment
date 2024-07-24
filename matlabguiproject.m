function varargout = matlabguiproject(varargin)
% MATLABGUIPROJECT MATLAB code for matlabguiproject.fig
%      MATLABGUIPROJECT, by itself, creates a new MATLABGUIPROJECT or raises the existing
%      singleton*.
%
%      H = MATLABGUIPROJECT returns the handle to a new MATLABGUIPROJECT or the handle to
%      the existing singleton*.
%
%      MATLABGUIPROJECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MATLABGUIPROJECT.M with the given input arguments.
%
%      MATLABGUIPROJECT('Property','Value',...) creates a new MATLABGUIPROJECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before matlabguiproject_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to matlabguiproject_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help matlabguiproject

% Last Modified by GUIDE v2.5 19-Dec-2017 01:48:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @matlabguiproject_OpeningFcn, ...
                   'gui_OutputFcn',  @matlabguiproject_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before matlabguiproject is made visible.
function matlabguiproject_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to matlabguiproject (see VARARGIN)

% Choose default command line output for matlabguiproject
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes matlabguiproject wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = matlabguiproject_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Calculate.
function Calculate_Callback(hObject, eventdata, handles)
% hObject    handle to Calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
typeofbeam=get(handles.typeofbeam,'SelectedObject')
type=get(typeofbeam,'String')
switch type
    case 'Simply Supported/Overhang'
if get(handles.PLCheckBox,'Value')==get(handles.PLCheckBox,'Max')
     P=str2num(get(handles.pointload,'String'));
    x=str2num(get(handles.pointloaddistance,'String'));
else
    P=0;
    x=0;
end
    if get(handles.UDLCB,'Value')==get(handles.UDLCB,'Max')
        w=str2num(get(handles.UDLmagnitude,'String'))
    span=str2num(get(handles.UDLspan,'String'))
    dis=str2num(get(handles.UDLdistance,'String'))
    else
        w=0;
        span=0;
        dis=0;
    end
    if get(handles.concMCB,'Value')== get(handles.concMCB,'Max')
    concmoment=str2num(get(handles.concmomentmag,'String'))
    concdistance=str2num(get(handles.concmomentdistance,'String'))
    else
       concmoment=0;
       concdistance=0;
    end
    L=str2num(get(handles.Lengthofbeam,'String'))
    distancebetweensupports=str2num(get(handles.distancebetweensupports,'String'))
      u=[x dis concdistance];
        if any(u<0)
            L=L-abs(min(u));
            l=linspace(min(u),L,1000);
        else
            l=linspace(0,L,1000);
        end
    totalmoment=sum(P.*x)+(sum(w.*span.*(dis+(span/2))))+sum(concmoment);
        sumofforces=sum(P)+sum(w.*span);
        ReactionatB=totalmoment/distancebetweensupports;
        ReactionatA=sumofforces-ReactionatB;
        V=ReactionatA*step_sf(l,0)-P*step_sf(l,x')...
            -w*lin_sf(l,dis')+w*lin_sf(l,(dis+span)')+...
            ReactionatB*step_fn(l,distancebetweensupports);
        M=ReactionatA*lin_sf(l,0)-P*lin_sf(l,x')-w/2*quad_sf(l,dis')...
            +w/2*quad_sf(l,(dis+span)')+...
            ReactionatB*lin_sf(l,distancebetweensupports)...
            +concmoment*step_sf(l,concdistance');
        plot(handles.shearforce,l,V,'color','r','linewidth',1.5)
        xlabel(handles.shearforce,'Distances in meters')
        ylabel(handles.shearforce,'Shear Force in kN')
        title(handles.shearforce,'Shear Force Diagram')
        line(handles.shearforce,[min(l),l(end)],[0 0],'color','k')
        plot(handles.bendingmoment,l,M,'color','r','linewidth',1.5)
        line(handles.bendingmoment,[min(l),l(end)],[0 0],'color','k')
        xlabel(handles.bendingmoment,'Distances in meters')
        ylabel(handles.bendingmoment,'Bending Moment in kNm')
        title(handles.bendingmoment,'Bending Moment Diagram')
        set(handles.ReactionatA,'String',ReactionatA)
        set(handles.ReactionatB,'String',ReactionatB)
        set(handles.maxbendingmoment,'String',max(M))
        set(handles.maxshearforce,'String',max(V))

case 'Cantilever'
        if get(handles.PLCheckBox,'Value')==get(handles.PLCheckBox,'Max')
     P=str2num(get(handles.pointload,'String'));
    x=str2num(get(handles.pointloaddistance,'String'));
else
    P=0;
    x=0;
end
    if get(handles.UDLCB,'Value')==get(handles.UDLCB,'Max')
        w=str2num(get(handles.UDLmagnitude,'String'))
    span=str2num(get(handles.UDLspan,'String'))
    dis=str2num(get(handles.UDLdistance,'String'))
    else
        w=0;
        span=0;
        dis=0;
    end
    if get(handles.concMCB,'Value')== get(handles.concMCB,'Max')
    concmoment=str2num(get(handles.concmomentmag,'String'))
    concdistance=str2num(get(handles.concmomentdistance,'String'))
    else
       concmoment=0;
       concdistance=0;
    end
        L=str2num(get(handles.Lengthofbeam,'String'));
         l=linspace(0,L,1000);
        sumofforces=sum(P)+sum(w.*span);
        totalmoments=sum(P.*x)+(sum(w.*span.*(dis+(span/2))))+sum(concmoment);
        ReactionatA=sumofforces;
        MA=totalmoments;
        V=ReactionatA*step_sf(l,0)-P*step_sf(l,x')...
            -w*lin_sf(l,dis')+w*lin_sf(l,(dis+span)');
        M=MA*step_sf(l,0)-ReactionatA*lin_sf(l,0)+P*lin_sf(l,x')...
            +w/2*quad_sf(l,dis')-w/2*quad_sf(l,(dis+span)')...
            -concmoment*step_sf(l,concdistance');
        plot(handles.shearforce,l,V,'color','r','linewidth',1.5)
        xlabel(handles.shearforce,'Distances in meters')
        ylabel(handles.shearforce,'Shear Force in kN')
        title(handles.shearforce,'Shear Force Diagram')
        line(handles.shearforce,[min(l),l(end)],[0 0],'color','k')
        plot(handles.bendingmoment,l,M,'color','r','linewidth',1.5)
        xlabel(handles.bendingmoment,'Distances in meters')
        ylabel(handles.bendingmoment,'Bending Moment in kNm')
        title(handles.bendingmoment,'Bending Moment Diagram')
        line(handles.bendingmoment,[min(l),l(end)],[0 0],'color','k')
        set(handles.ReactionatA,'String',ReactionatA)
        set(handles.supportmoment,'String',MA)
        set(handles.maxbendingmoment,'String',max(M))
        set(handles.maxshearforce,'String',max(V))
       
    end

function ReactionatA_Callback(hObject, eventdata, handles)
% hObject    handle to ReactionatA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ReactionatA as text
%        str2double(get(hObject,'String')) returns contents of ReactionatA as a double


% --- Executes during object creation, after setting all properties.
function ReactionatA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ReactionatA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Reactionatb_Callback(hObject, eventdata, handles)
% hObject    handle to Reactionatb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Reactionatb as text
%        str2double(get(hObject,'String')) returns contents of Reactionatb as a double


% --- Executes during object creation, after setting all properties.
function Reactionatb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Reactionatb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Lengthofbeam_Callback(hObject, eventdata, handles)
% hObject    handle to Lengthofbeam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Lengthofbeam as text
%        str2double(get(hObject,'String')) returns contents of Lengthofbeam as a double
L=str2num(get(handles.Lengthofbeam,'String'));
if L<=0
errordlg('You must enter a valid length','Invalid Input','modal')
uicontrol(handles.Lengthofbeam)
return
end

% --- Executes during object creation, after setting all properties.
function Lengthofbeam_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Lengthofbeam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function distancebetweensupports_Callback(hObject, eventdata, handles)
% hObject    handle to distancebetweensupports (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of distancebetweensupports as text
%        str2double(get(hObject,'String')) returns contents of distancebetweensupports as a double
if isempty(get(handles.Lengthofbeam,'String'))
    errordlg('You must enter the length of the beam','Invalid Input','modal')
    uicontrol(handles.Lengthofbeam)
return
end
D=str2num(get(handles.distancebetweensupports,'String'));
L=str2num(get(handles.Lengthofbeam,'String'));
if D<=0||D>L
    errordlg('You must enter a valid distance','Invalid Input','modal')
    uicontrol(handles.distancebetweensupports)
return
end

% --- Executes during object creation, after setting all properties.
function distancebetweensupports_CreateFcn(hObject, eventdata, handles)
% hObject    handle to distancebetweensupports (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PLCheckBox.
function PLCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to PLCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PLCheckBox



function pointloaddistance_Callback(hObject, eventdata, handles)
% hObject    handle to pointloaddistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(get(handles.Lengthofbeam,'String'))
    errordlg('You must enter the length of the beam','Invalid Input','modal')
    uicontrol(handles.Lengthofbeam)
return
end
L=str2num(get(handles.Lengthofbeam,'String'));
D=str2num(get(handles.pointloaddistance,'String'));
if any(abs(D)>L)
    errordlg('You must enter a valid distance','Invalid Input','modal')
    uicontrol(handles.pointloaddistance)
return
end
% Hints: get(hObject,'String') returns contents of pointloaddistance as text
%        str2double(get(hObject,'String')) returns contents of pointloaddistance as a double


% --- Executes during object creation, after setting all properties.
function pointloaddistance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pointloaddistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pointload_Callback(hObject, eventdata, handles)
% hObject    handle to pointload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pointload as text
%        str2double(get(hObject,'String')) returns contents of pointload as a double


% --- Executes during object creation, after setting all properties.
function pointload_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pointload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in UDLCB.
function UDLCB_Callback(hObject, eventdata, handles)
% hObject    handle to UDLCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of UDLCB



function UDLmagnitude_Callback(hObject, eventdata, handles)
% hObject    handle to UDLmagnitude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of UDLmagnitude as text
%        str2double(get(hObject,'String')) returns contents of UDLmagnitude as a double


% --- Executes during object creation, after setting all properties.
function UDLmagnitude_CreateFcn(hObject, eventdata, handles)
% hObject    handle to UDLmagnitude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function UDLdistance_Callback(hObject, eventdata, handles)
% hObject    handle to UDLdistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(get(handles.Lengthofbeam,'String'))
    errordlg('You must enter the length of the beam','Invalid Input','modal')
    uicontrol(handles.Lengthofbeam)
return
end
L=str2num(get(handles.Lengthofbeam,'String'));
D=str2num(get(handles.UDLdistance,'String'));
if any(abs(D)>L)
    errordlg('You must enter a valid distance','Invalid Input','modal')
    uicontrol(handles.UDLdistance)
return
end
% Hints: get(hObject,'String') returns contents of UDLdistance as text
%        str2double(get(hObject,'String')) returns contents of UDLdistance as a double


% --- Executes during object creation, after setting all properties.
function UDLdistance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to UDLdistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function UDLspan_Callback(hObject, eventdata, handles)
% hObject    handle to UDLspan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of UDLspan as text
%        str2double(get(hObject,'String')) returns contents of UDLspan as a double
if isempty(get(handles.Lengthofbeam,'String'))
    errordlg('You must enter the length of the beam','Invalid Input','modal')
    uicontrol(handles.Lengthofbeam)
return
end
L=str2num(get(handles.Lengthofbeam,'String'));
D=str2num(get(handles.UDLspan,'String'));
if any(D>L)||D<=0
    errordlg('You must enter a valid distance','Invalid Input','modal')
    uicontrol(handles.UDLspan)
return
end

% --- Executes during object creation, after setting all properties.
function UDLspan_CreateFcn(hObject, eventdata, handles)
% hObject    handle to UDLspan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in concMCB.
function concMCB_Callback(hObject, eventdata, handles)
% hObject    handle to concMCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of concMCB



function concmomentmag_Callback(hObject, eventdata, handles)
% hObject    handle to concmomentmag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of concmomentmag as text
%        str2double(get(hObject,'String')) returns contents of concmomentmag as a double


% --- Executes during object creation, after setting all properties.
function concmomentmag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to concmomentmag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function concmomentdistance_Callback(hObject, eventdata, handles)
% hObject    handle to concmomentdistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(get(handles.Lengthofbeam,'String'))
    errordlg('You must enter the length of the beam','Invalid Input','modal')
    uicontrol(handles.Lengthofbeam)
return
end
L=str2num(get(handles.Lengthofbeam,'String'));
D=str2num(get(handles.concmomentdistance,'String'));
if any(abs(D)>L)
    errordlg('You must enter a valid distance','Invalid Input','modal')
    uicontrol(handles.concmomentdistance)
return
end
% Hints: get(hObject,'String') returns contents of concmomentdistance as text
%        str2double(get(hObject,'String')) returns contents of concmomentdistance as a double


% --- Executes during object creation, after setting all properties.
function concmomentdistance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to concmomentdistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SimplySupportedBeam.
function SimplySupportedBeam_Callback(hObject, eventdata, handles)
% hObject    handle to SimplySupportedBeam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of SimplySupportedBeam
    
% --- Executes on button press in Cantilever.

function Cantilever_Callback(hObject, eventdata, handles)
% hObject    handle to Cantilever (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of Cantilever

function Supportmoment_Callback(hObject, eventdata, handles)
% hObject    handle to Supportmoment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Supportmoment as text
%        str2double(get(hObject,'String')) returns contents of Supportmoment as a double


% --- Executes during object creation, after setting all properties.
function Supportmoment_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Supportmoment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxbendingmoment_Callback(hObject, eventdata, handles)
% hObject    handle to maxbendingmoment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxbendingmoment as text
%        str2double(get(hObject,'String')) returns contents of maxbendingmoment as a double


% --- Executes during object creation, after setting all properties.
function maxbendingmoment_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxbendingmoment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
    
    % --- Executes on button press in UDLCB.
   

end


% --- Executes on button press in Reset.
function Reset_Callback(hObject, eventdata, handles)
% hObject    handle to Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pointload,'String',[])
set(handles.pointloaddistance,'String',[])
set(handles.UDLmagnitude,'String',[])
set(handles.UDLdistance,'String',[])
set(handles.UDLspan,'String',[])
set(handles.concmomentmag,'String',[])
set(handles.concmomentdistance,'String',[])
set(handles.Lengthofbeam,'String',[])
set(handles.distancebetweensupports,'String',[])
set(handles.ReactionatA,'String',[])
set(handles.ReactionatB,'String',[])
set(handles.supportmoment,'String',[])
set(handles.maxbendingmoment,'String',[])
set(handles.maxshearforce,'String',[])
cla(handles.shearforce,'reset')
cla(handles.bendingmoment,'reset')


% --- Executes during object creation, after setting all properties.
function uipanel1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when selected object is changed in typeofbeam.
function typeofbeam_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in typeofbeam 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch(get(eventdata.NewValue,'Tag'))
    case 'cantilever'
        set(handles.distancebetweensupports,'Visible','off')
        set(handles.DBS,'Visible','off')
    case 'simply'
        set(handles.distancebetweensupports,'Visible','on')
        set(handles.DBS,'Visible','on')
end
