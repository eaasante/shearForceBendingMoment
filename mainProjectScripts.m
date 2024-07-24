%This function plots the bending moment and shear force diagrams for a
%simply supported beam or overhang beam and cantilever for all load cases.
%For the simply supported beam/overhang, the user enters the magnitude and
%distances of point load(s),UDLs and concentrated moments according to their number
%on the beam.
%If distances are to the left of the left support,the user must enter a
%negative value, but if it's to the right of the left support, the user
%must enter a positive value.
%If concentrated moment is to the left of the left support, enter it's
%magnitude as a negative value.
clc
clear 
disp('1.Simply supported beam/overhang')
disp('2.Cantilever')
choice=input('Please select any of the above: ');
while choice<1||choice>2
    choice=input('Invalid! Select a valid choice: ');
end
if choice==1
    clc
    disp('1.Simply supported beam with only point loads on the span')
    disp('2.Simply supported beam  with only UDl(s) on the span')
    disp('3.Simply supported beam with UDL and point loads on the span')
    disp('4.Simply supported beam with UDL(s),point load(s) and concentrated moment(s) on the span')
    n=input('Please select any of the above: ');
    while (n<1)||(n>4)
        n=input('Invalid! Select a valid choice: ');
    end
    clc
    L=input('Enter the length of the beam: ');
    while L<=0
        L=input('Invalid! Enter a valid length: ');
    end
    switch n
        case 1
             k=input('Enter the number of point loads: ');
             while k<0
                 k=input('Invalid! Enter a valid number: ');
             end
        P=zeros(1,k);
        x=zeros(1,k);
        for i=1:k
            inputload=input('Enter the magnitude of the point load in kN: ');
            inputdistance=input('Enter it''s distance from the left support in meters: ');
            while inputdistance>L
                inputdistance=input('Invalid! Enter a valid length: ');
            end
            P(i)=inputload;
            x(i)=inputdistance; 
        end
        if any(x<0)
            u=L-abs(min(x));
            l=linspace(min(x),u,1000);
        else
            l=linspace(0,L,1000);
        end
        RBx=input('Enter distance between left support and right support in meters: ');
        while RBx<=0||RBx>L
            RBx=input('Invalid! Enter a valid distance: ');
        end
        moment=sum(P.*x);
        Sum_of_forces=sum(P);
        RB=moment/RBx; 
        RA=Sum_of_forces-RB;
        V=RA*step_sf(l,0)-P*step_sf(l,x')+RB*step_sf(l,RBx);
        M=RA*lin_sf(l,0)-P*lin_sf(l,x')+RB*lin_sf(l,RBx);
        maxl=max(l);
        minl=min(l);
        subplot 211
        plot(l,V,'r','linewidth',1.5)
         line([min(l),l(end)],[0 0],'color','k')
        line([l(end) l(end)],[0 V(end)],'color','r','linewidth',1.5)
         xlabel('\bf Distances in meters')
        ylabel('\bf Shear Force in kN')
        title('\it Shear Force diagram','FontSize',18)
         subplot 212
         plot(l,M,'r','linewidth',1.5)
          line([min(l),l(end)],[0 0],'color','k')
        xlabel('\bf Distances in meters')
        ylabel('\bf Bending Moment in kNm')
        title('\it Bending Moment Diagram','Fontsize',18)
        fprintf('RA=%.2fkN\n',RA)
        fprintf('RB=%.2fkN\n',RB)
    case 2 
        k=input('Enter the number of UDls: ');
         while k<0
                 k=input('Invalid! Enter a valid number: ');
         end
          w=zeros(1,k);
        span=zeros(1,k);
        dis=zeros(1,k);
        for i=1:k
        wx=input('Enter the magnitude of the UDL in kN/m: '); %magnitude of UDL
        spanx=input('Enter the span of the UDL in meters: '); %span of UDL
         while spanx<=0||spanx>L
            spanx=input('Invalid! Enter a valid span: ');
        end
        disx=input('Enter the distance of the left end of UDL from the left support in meters: ');
         while abs(disx)>L-span
            disx=input('Invalid! Enter a valid distance: ');
        end
        w(i)=wx;
        span(i)=spanx;
        dis(i)=disx;
        end
         if any(dis<0)
            u=L-abs(min(x));
            l=linspace(min(x),u,1000);
        else
            l=linspace(0,L,2000);
        end
        %Distance of UDL from left support
        distancebetweensupports=input('Enter distance between left support and right support in meters: ');
         while distancebetweensupports<=0||distancebetweensupports>L
            distancebetweensupports=input('Invalid! Enter a valid distance: ');
        end
        intensityofUDL=w.*span;
        centroid=dis+(span/2);
        ReactionatB=(sum(intensityofUDL.*(centroid)))/distancebetweensupports;
        ReactionatA=(sum(intensityofUDL))-ReactionatB;
        V=ReactionatA*step_sf(l,0)-w*lin_sf(l,dis')+w*lin_sf(l,(dis+span)')+ReactionatB*step_sf(l,L);
        M=ReactionatA*lin_sf(l,0)-w/2*quad_sf(l,dis')+w/2*quad_sf(l,(dis+span)');
        MaximumMoment=max(M);
        subplot 211
        plot(l,V,'r','linewidth',1.5)
        line([min(l),l(end)],[0 0],'color','k')
        line([l(end) l(end)],[0 V(end)],'color','r','linewidth',1.5)
         xlabel('\bf Distances in meters')
        ylabel('\bf Shear Force in kN')
        title('\it Shear Force diagram','FontSize',18)
        subplot 212
        plot(l,M,'r','linewidth',1.5)
        line([min(l),l(end)],[0 0],'color','k')
        xlabel('\bf Distances in meters')
        ylabel('\bf Bending Moment in kNm')
        title('\it Bending Moment Diagram','FontSize',18)
        fprintf('RA=%.2fkN\n',ReactionatA)
        fprintf('RB=%.2fkN\n',ReactionatB)
    case 3
        k=input('Enter the number of point loads: ');
         while k<0
                 k=input('Invalid! Enter a valid number: ');
         end
        P=zeros(1,k);
        x=zeros(1,k);
        for i=1:k
            inputload=input('Enter the magnitude of the point load in kN: ');
            inputdistance=input('Enter it''s distance from the left support in meters: ');
             while inputdistance>L
                inputdistance=input('Invalid! Enter a valid length: ');
            end
            P(i)=inputload;
            x(i)=inputdistance;
        end
        c=input('Enter the number of UDLs: ');
         while c<0
                 c=input('Invalid! Enter a valid number: ');
         end
         w=zeros(1,c);
        span=zeros(1,c);
        dis=zeros(1,c);
        for i=1:c
         wx=input('Enter the magnitude of the UDL in kN/m: '); %magnitude of UDL
        spanx=input('Enter the span of the UDL in meters: '); %span of UDL
         while spanx<=0||spanx>L
            spanx=input('Invalid! Enter a valid span: ');
        end
        disx=input('Enter the distance of the left end of UDL from the left support in meters: ');
         while disx>=L
            disx=input('Invalid! Enter a valid distance: ');
        end
         w(i)=wx;
        span(i)=spanx;
        dis(i)=disx;
        end
        u=[x dis];
        if any(u<0)
            L=L-abs(min(u));
            l=linspace(min(u),L,1000);
        else
            l=linspace(0,L,1000);
        end
        distancebetweensupports=input('Enter distance between left support and right support in meters: ');
         while distancebetweensupports<=0||distancebetweensupports>L
            distancebetweensupports=input('Invalid! Enter a valid distance: ');
        end
        totalmoment=sum(P.*x)+(sum(w.*span.*(dis+(span/2))));
        sumofforces=sum(P)+sum(w.*span);
        ReactionatB=totalmoment/distancebetweensupports;
        ReactionatA=sumofforces-ReactionatB;
        V=ReactionatA*step_sf(l,0)-P*step_sf(l,x')...
            -w*lin_sf(l,dis')+w*lin_sf(l,(dis+span)')+ReactionatB*step_sf(l,distancebetweensupports);
        M=ReactionatA*lin_sf(l,0)-P*lin_sf(l,x')-w/2*quad_sf(l,dis')...
            +w/2*quad_sf(l,(dis+span)')+ReactionatB*lin_sf(l,distancebetweensupports);
        subplot 211
        plot(l,V,'r','linewidth',1.5)
        line([min(l),l(end)],[0 0],'color','k')
        line([l(end) l(end)],[0 V(end)],'color','r','linewidth',1.5)
        xlabel('\bf Distances in meters')
        ylabel('\bf Shear Force in kN')
        title('\it Shear Force diagram','FontSize',18)
        subplot 212
        plot(l,M,'r','linewidth',1.5)
        line([min(l),l(end)],[0 0],'color','k')
        xlabel('\bf Distances in meters')
        ylabel('\bf Bending Moment in kNm')
        title('\it Bending Moment Diagram','FontSize',18)
        fprintf('RA=%.2fkN\n',ReactionatA)
        fprintf('RB=%.2fkN\n',ReactionatB) 
    case 4
          k=input('Enter the number of point loads: ');
           while k<0
                 k=input('Invalid! Enter a valid number: ');
           end
        P=zeros(1,k);
        x=zeros(1,k);
        for i=1:k
            inputload=input('Enter the magnitude of the point load in kNm: ');
            inputdistance=input('Enter it''s distance from the left support in meters: ');
             while inputdistance>L
                inputdistance=input('Invalid! Enter a valid length: ');
            end
            P(i)=inputload;
            x(i)=inputdistance;
        end
         c=input('Enter the number of UDLs: ');
          while c<0
                 c=input('Invalid! Enter a valid number: ');
          end
         w=zeros(1,c);
        span=zeros(1,c);
        dis=zeros(1,c);
        for i=1:c
         wx=input('Enter the magnitude of the UDL in kN/m: '); %magnitude of UDL
        spanx=input('Enter the span of the UDL in meters: '); %span of UDL
         while spanx<=0||spanx>L
            spanx=input('Invalid! Enter a valid span: ');
        end
        disx=input('Enter the distance of the left end of UDL from the left support in meters: ');
        while disx>=L
            disx=input('Invalid! Enter a valid distance: ');
        end
         w(i)=wx;
        span(i)=spanx;
        dis(i)=disx;
        end
        conc=input('Enter the number of concentrated moment(s): ');
         while conc<0
                 conc=input('Invalid! Enter a valid number: ');
         end
        concmoment=zeros(1,conc);
        concdistance=zeros(1,conc);
        for i=1:conc
        cm=input('Enter magnitude of concentrated moment in kNm: ');
        cmdis=input('Enter it''s distance from the left support in metres: ');
        while cmdis>L
            cmdis=input('Invalid! Enter a valid distance: ');
        end
        concmoment(i)=cm;
        concdistance(i)=cmdis;
        end
         u=[x dis concdistance];
        if any(u<0)
            L=L-abs(min(u));
            l=linspace(min(u),L,1000);
        else
            l=linspace(0,L,1000);
        end
         distancebetweensupports=input('Enter distance between left support and right support in meters: ');
          while distancebetweensupports<=0||distancebetweensupports>L
            distancebetweensupports=input('Invalid! Enter a valid distance: ');
          end
        totalmoment=sum(P.*x)+(sum(w.*span.*(dis+(span/2))))+sum(concmoment);
        sumofforces=sum(P)+sum(w.*span);
        ReactionatB=totalmoment/distancebetweensupports;
        ReactionatA=sumofforces-ReactionatB;
        V=ReactionatA*step_sf(l,0)-P*step_sf(l,x')...
            -w*lin_sf(l,dis')+w*lin_sf(l,(dis+span)')+ReactionatB*step_sf(l,distancebetweensupports);
        M=ReactionatA*lin_sf(l,0)-P*lin_sf(l,x')-w/2*quad_sf(l,dis')...
            +w/2*quad_sf(l,(dis+span)')+ReactionatB*lin_sf(l,distancebetweensupports)...
            +concmoment*step_sf(l,concdistance');
        subplot 211
        plot(l,V,'r','linewidth',1.5)
        line([min(l),l(end)],[0 0],'color','k')
        line([l(end) l(end)],[0 V(end)],'color','r','linewidth',1.5)
        xlabel('\bf Distances in meters')
        ylabel('\bf Shear Force in kN')
        title('\it Shear Force diagram','FontSize',18)
        subplot 212
        plot(l,M,'r','linewidth',1.5)
        line([min(l),l(end)],[0 0],'color','k')
         line([l(end) l(end)],[0 M(end)],'color','r','linewidth',1.5)
        xlabel('\bf Distances in meters')
        ylabel('\bf Bending Moment in kNm')
        title('\it Bending Moment Diagram','FontSize',18)
        fprintf('Reaction at left suport=%.2fkN\n',ReactionatA)
        fprintf('Reaction at right support=%.2fkN\n',ReactionatB) 
    end
else 
            clc
            disp('1.Cantilever with only point loads on the span')
            disp('2.Cantilever with only UDL(s) across the span')
            disp('3.Cantilever with point load(s) and UDL(s) across the span')
            disp('4.Cantilever with point load(s),UDL(s) and concentrated moment(s) across the span')
            n=input('Please select any of the above: ');
            while (n<1)||(n>4)
                n=input('Invalid! select a valid choice: ');
            end
            clc
            L=input('Enter the length of the beam: ');
            while L<=0
                L=input('Invalid! Enter a valid length: ');
            end
            switch n
                case 1
                     k=input('Enter the number of point loads: ');
                      while k<0
                 k=input('Invalid! Enter a valid number: ');
                      end
                     P=zeros(1,k);
                     x=zeros(1,k);
        for i=1:k
            inputload=input('Enter the magnitude of the point load in kN: ');
            inputdistance=input('Enter it''s distance from the support in meters: ');
            while inputdistance>L||inputdistance<0
                inputdistance=input('Invalid! Enter a valid length: ');
            end
            P(i)=inputload;
            x(i)=inputdistance; 
        end
        l=linspace(0,L,1000);
        sumofforces=sum(P);
        RA=sumofforces;
        sumofmoments=sum(P.*x);
        MA=sumofmoments;
        V=RA*step_sf(l,0)-P*step_sf(l,x');
        M=MA*step_sf(l,0)-RA*lin_sf(l,0)+P*lin_sf(l,x');
        subplot 211
        plot(l,V,'r','linewidth',1.5)
        line([min(l),l(end)],[0 0],'color','k')
        line([l(end) l(end)],[0 V(end)],'color','r','linewidth',1.5)
        xlabel('\bf Distances in meters')
        ylabel('\bf Shear Force in kN')
        title('\it Shear Force diagram','Fontsize',18)
        subplot 212
        plot(l,M,'r')
        line([min(l),l(end)],[0 0],'color','k')
        line([l(end) l(end)],[0 M(end)],'color','r','linewidth',1.5)
        xlabel('\bf Distances in meters')
        ylabel('\bf Bending Moment in kNm')
        title('\it Bending Moment Diagram','FontSize',18)
        fprintf('RA=%.2f\n',RA)
        fprintf('MA=%.2f\n',MA)
    case 2
         k=input('Enter the number of UDls: ');
          while k<0
                 k=input('Invalid! Enter a valid number: ');
          end
        w=zeros(1,k);
        span=zeros(1,k);
        dis=zeros(1,k);
        for i=1:k
        wx=input('Enter the magnitude of the UDL in kN/m: '); %magnitude of UDL
        spanx=input('Enter the span of the UDL in meters: '); %span of UDL
        while spanx<=0||spanx>L
            spanx=input('Invalid! Enter a valid span');
        end
        disx=input('Enter the distance of the left end of UDL from the support in meters: ');
         while disx<0||disx>=L
            disx=input('Invalid! Enter a valid distance: ');
        end
        w(i)=wx;
        span(i)=spanx;
        dis(i)=disx;
        end
        l=linspace(0,L,1000);
        intensityofUDL=sum(w.*span);
        centroid=dis+(span/2);
        sumofmoments=sum(intensityofUDL.*(centroid));
        RA=intensityofUDL;
        MA=sumofmoments;
        V=RA*step_sf(l,0)...
             -w*lin_sf(l,dis')+w*lin_sf(l,(dis+span)');
        M=MA*step_sf(l,0)-RA*lin_sf(l,0)+w/2*quad_sf(l,dis')-w/2*quad_sf(l,(dis+span)');
        subplot 211
        plot(l,V,'r','linewidth',1.5)
        line([min(l),l(end)],[0 0],'color','k')
        line([l(end) l(end)],[0 V(end)],'color','r','linewidth',1.5)
         xlabel('\bf Distances in meters')
        ylabel('bf Shear Force in kN')
        title('\it Shear Force diagram','FontSize',18)
        subplot 212
        plot(l,M,'r','linewidth',1.5)
        line([min(l),l(end)],[0 0],'color','k')
        line([l(end) l(end)],[0 M(end)],'color','r','linewidth',1.5)
        xlabel('\bf Distances in meters')
        ylabel('\bf Bending Moment in kNm')
        title('\it Bending Moment Diagram','FontSize',18)
        fprintf('RA=%.2f\n',RA)
        fprintf('MA=%.2f\n',MA)
    case 3
         k=input('Enter the number of point loads: ');
          while k<0
                 k=input('Invalid! Enter a valid number: ');
          end
        P=zeros(1,k);
        x=zeros(1,k);
        for i=1:k
            inputload=input('Enter the magnitude of the point load in kN: ');
            inputdistance=input('Enter it''s distance from the support in meters: ');
            P(i)=inputload;
            x(i)=inputdistance;
        end
        k=input('Enter the number of UDLs: ');
         while k<0
                 k=input('Invalid! Enter a valid number: ');
         end
         w=zeros(1,k);
        span=zeros(1,k);
        dis=zeros(1,k);
        for i=1:k
         wx=input('Enter the magnitude of the UDL in kN/m: '); %magnitude of UDL
        spanx=input('Enter the span of the UDL in meters: '); %span of UDL
         while spanx<=0||spanx>L
            spanx=input('Invalid! Enter a valid span: ');
        end
        disx=input('Enter the distance of the left end of UDL from the support in meters: ');
         while disx<0||disx>=L
            disx=input('Invalid! Enter a valid distance: ');
        end
         w(i)=wx;
        span(i)=spanx;
        dis(i)=disx;
        end
        l=linspace(0,L,1000);
        sumofforces=sum(P)+sum(w.*span);
        totalmoments=sum(P.*x)+(sum(w.*span.*(dis+(span/2))));
        RA=sumofforces;
        MA=totalmoments;
        V=RA*step_sf(l,0)-P*step_sf(l,x')...
            -w*lin_sf(l,dis')+w*lin_sf(l,(dis+span)');
        M=MA*step_sf(l,0)-RA*lin_sf(l,0)+P*lin_sf(l,x')...
            +w/2*quad_sf(l,dis')-w/2*quad_sf(l,(dis+span)');
        subplot 211
        plot(l,V,'r','linewidth',1.5)
        line([min(l),l(end)],[0 0],'color','k')
        line([l(end) l(end)],[0 V(end)],'color','r','linewidth',1.5)
         xlabel('\bf Distances in meters')
        ylabel('\bf Shear Force in kN')
        title('\it Shear Force diagram','FontSize',18)
        subplot 212
        plot(l,M,'r','linewidth',1.5)
        line([min(l),l(end)],[0 0],'color','k')
         xlabel('\bf Distances in meters')
         line([l(end) l(end)],[0 M(end)],'color','r','linewidth',1.5)
        ylabel('\bf Bending Moment in kNm')
        title('\it Bending Moment Diagram')
        fprintf('Reaction at support=%.2fkN\n',RA)
        fprintf('Moment at support=%.2fkNm\n',MA) 
    case 4
         k=input('Enter the number of point loads: ');
          while k<0
                 k=input('Invalid! Enter a valid number: ');
          end
        P=zeros(1,k);
        x=zeros(1,k);
        for i=1:k
            inputload=input('Enter the magnitude of the point load in kN: ');
            inputdistance=input('Enter it''s distance from the support in meters: ');
            while inputdistance<0||inputdistance>L
                inputdistance=input('Invalid! Enter a valid distance: ');
            end
            P(i)=inputload;
            x(i)=inputdistance;
        end
        k=input('Enter the number of UDLs: ');
         while k<0
                 k=input('Invalid! Enter a valid number: ');
         end
         w=zeros(1,k);
        span=zeros(1,k);
        dis=zeros(1,k);
        for i=1:k
         wx=input('Enter the magnitude of the UDL in kN/m: '); %magnitude of UDL
        spanx=input('Enter the span of the UDL in meters: '); %span of UDL
        while spanx<=0||spanx>L
            spanx=input('Invalid! Enter a valid span: ');
        end
        disx=input('Enter the distance of the left end of UDL from the support in meters: ');
        while disx<0||disx>=L
            disx=input('Invalid! Enter a valid distance: ');
        end
         w(i)=wx;
        span(i)=spanx;
        dis(i)=disx;
        end
         conc=input('Enter the number of concentrated moment(s): ');
          while conc<0
                 conc=input('Invalid! Enter a valid number: ');
          end
        concmoment=zeros(1:conc);
        concdistance=zeros(1:conc);
        for i=1:conc
        cm=input('Enter magnitude of concentrated moment in kNm: ');
        cmdis=input('Enter it''s distance from the support in metres: ');
        while cmdis>L
            cmdis=input('Inalid! Enter a valid distance: ');
        end
        concmoment(i)=cm;
        concdistance(i)=cmdis;
        end
        l=linspace(0,L,1000); 
        sumofforces=sum(P)+sum(w.*span);
        totalmoments=sum(P.*x)+(sum(w.*span.*(dis+(span/2))))+sum(concmoment);
        RA=sumofforces;
        MA=totalmoments;
        V=RA*step_sf(l,0)-P*step_sf(l,x')...
            -w*lin_sf(l,dis')+w*lin_sf(l,(dis+span)');
        M=MA*step_sf(l,0)-RA*lin_sf(l,0)+P*lin_sf(l,x')...
            +w/2*quad_sf(l,dis')-w/2*quad_sf(l,(dis+span)')...
            -concmoment*step_sf(l,concdistance');
        subplot 211
        plot(l,V,'r','linewidth',1.5)
        line([min(l),l(end)],[0 0],'color','k')
         line([l(end) l(end)],[0 V(end)],'color','r','linewidth',1.5)
         xlabel('\bf Distances in meters')
        ylabel('\bf Shear Force in kN')
        title('\it Shear Force diagram','FontSize',18)
        subplot 212
        plot(l,M,'r','linewidth',1.5)
        line([min(l),l(end)],[0 0],'color','k')
        line([l(end) l(end)],[0 M(end)],'color','r','linewidth',1.5)
         xlabel('\bf Distances in meters')
        ylabel('\bf Bending Moment in kNm')
        title('\it Bending Moment Diagram','FontSize',18)
        fprintf('Reaction at support=%.2fkN\n',RA)
        fprintf('Moment at support=%.2fkNm\n',MA) 
            end
end
                

            