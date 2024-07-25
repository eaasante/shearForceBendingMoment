"""
This program plots the bending moment and shear force diagrams for a
simply supported beam, an overhang beam, and a cantilever for all load cases.
For a simply supported beam/overhang, the user must enter the magnitude of the loads 
and the distances of the load application points from the leftmost support according to
their position on the beam.
If the loads are located to the left of the leftmost support, their distances
must be assigned negative values. Otherwise, all distances must be positive.
If a concentrated moment is located to the left of the left support, enter its
magnitude as a negative value.
"""

import numpy as np
import matplotlib.pypl
import pyinputplus as pyin

def step_sf(x, a):
    return np.heaviside(x - a, 1)

def lin_sf(x, a):
    return (x - a) * step_sf(x, a)

def quad_sf(x, a):
    return 0.5 * (x - a) ** 2 * step_sf(x, a)

def main():
    print('1. Simply supported beam/overhang')
    print('2. Cantilever')
    choice = pyin.inputInt('Please select any of the above: ', min=1, max=2)
    if choice == 1:
        print('1. Simply supported beam with only point loads on the span')
        print('2. Simply supported beam with only UDL(s) on the span')
        print('3. Simply supported beam with UDL and point loads on the span')
        print('4. Simply supported beam with UDL(s), point load(s) and concentrated moment(s) on the span')
        n = int(pyin.inputInt('Please select any of the above: ', min=1, max=4))

        L = pyin.inputFloat('Enter the length of the beam: ', min=0)

        if n == 1:
            k = pyin.inputInt('Enter the number of point loads: ', min=0)
            P = np.zeros(k)
            x = np.zeros(k)
            for i in range(k):
                inputload = pyin.inputFloat('Enter the magnitude of the point load in kN: ')
                inputdistance = pyin.inputFloat('Enter its distance from the left support in meters: ', max=L)
                P[i] = inputload
                x[i] = inputdistance

            if np.any(x < 0):
                u = L - abs(np.min(x))
                l = np.linspace(np.min(x), u, 1000)
            else:
                l = np.linspace(0, L, 1000)
            moment = np.sum(P * x)
            Sum_of_forces = np.sum(P)
            RB = moment / L
            RA = Sum_of_forces - RB
            V = RA * step_sf(l, 0) - np.sum([P[i] * step_sf(l, x[i]) for i in range(k)], axis=0) + RB * step_sf(l, L)
            M = RA * lin_sf(l, 0) - np.sum([P[i] * lin_sf(l, x[i]) for i in range(k)], axis=0) + RB * lin_sf(l, L)

            plt.subplot(211)
            plt.plot(l, V, 'r', linewidth=1.5)
            plt.axhline(0, color='k')
            plt.axvline(l[-1], color='r', linewidth=1.5)
            plt.xlabel('Distances in meters')
            plt.ylabel('Shear Force in kN')
            plt.title('Shear Force diagram')

            plt.subplot(212)
            plt.plot(l, M, 'r', linewidth=1.5)
            plt.axhline(0, color='k')
            plt.axvline(l[-1], color='r', linewidth=1.5)
            plt.xlabel('Distances in meters')
            plt.ylabel('Bending Moment in kNm')
            plt.title('Bending Moment Diagram')

            print(f'RA={RA:.2f} kN')
            print(f'RB={RB:.2f} kN')

            plt.show()

        elif n == 2:
            k = pyin.inputInt('Enter the number of UDLs: ', min=0)
            w = np.zeros(k)
            span = np.zeros(k)
            dis = np.zeros(k)
            for i in range(k):
                wx = pyin.Float('Enter the magnitude of the UDL in kN/m: ')
                spanx = pyin.Float('Enter the span of the UDL in meters: ', min=0, max=L)
                disx = pyin.Float('Enter the distance of the left end of UDL from the left support in meters: ', min=spanx-L, max=L-spanx)
                w[i] = wx
                span[i] = spanx
                dis[i] = disx

            if np.any(dis < 0):
                u = L - abs(np.min(dis))
                l = np.linspace(np.min(dis), u, 1000)
            else:
                l = np.linspace(0, L, 1000)

            intensityofUDL = w * span
            centroid = dis + (span / 2)
            ReactionatB = np.sum(intensityofUDL * centroid) / L
            ReactionatA = np.sum(intensityofUDL) - ReactionatB
            V = ReactionatA * step_sf(l, 0) - np.sum([w[i] * lin_sf(l, dis[i]) for i in range(k)], axis=0) + np.sum([w[i] * lin_sf(l, dis[i] + span[i]) for i in range(k)], axis=0) + ReactionatB * step_sf(l, L)
            M = ReactionatA * lin_sf(l, 0) - np.sum([w[i] * quad_sf(l, dis[i]) for i in range(k)], axis=0) + np.sum([w[i] * quad_sf(l, dis[i] + span[i]) for i in range(k)], axis=0) + ReactionatB * lin_sf(l, L)

            plt.subplot(211)
            plt.plot(l, V, 'r', linewidth=1.5)
            plt.axhline(0, color='k')
            plt.axvline(l[-1], color='r', linewidth=1.5)
            plt.xlabel('Distances in meters')
            plt.ylabel('Shear Force in kN')
            plt.title('Shear Force diagram')

            plt.subplot(212)
            plt.plot(l, M, 'r', linewidth=1.5)
            plt.axhline(0, color='k')
            plt.axvline(l[-1], color='r', linewidth=1.5)
            plt.xlabel('Distances in meters')
            plt.ylabel('Bending Moment in kNm')
            plt.title('Bending Moment Diagram')

            print(f'RA={ReactionatA:.2f} kN')
            print(f'RB={ReactionatB:.2f} kN')

            plt.show()

        elif n == 3:
            k = pyin.inputInt('Enter the number of point loads: ', min=0)
            P = np.zeros(k)
            x = np.zeros(k)
            for i in range(k):
                inputload = pyin.inputFloat('Enter the magnitude of the point load in kN: ')
                inputdistance = pyin.inputFloat('Enter its distance from the left support in meters: ', max=L)
                P[i] = inputload
                x[i] = inputdistance

            c = pyin.inputInt('Enter the number of UDLs: ', min=0)

            w = np.zeros(c)
            span = np.zeros(c)
            dis = np.zeros(c)
            for i in range(c):
                wx = float(input('Enter the magnitude of the UDL in kN/m: '))
                spanx = float(input('Enter the span of the UDL in meters: '))
                while spanx <= 0 or spanx > L:
                    spanx = float(input('Invalid! Enter a valid span: '))
                disx = float(input('Enter the distance of the left end of UDL from the left support in meters: '))
                while disx >= L:
                    disx = float(input('Invalid! Enter a valid distance: '))
                w[i] = wx
                span[i] = spanx
                dis[i] = disx

            u = np.concatenate((x, dis))
            if np.any(u < 0):
                L = L - abs(np.min(u))
                l = np.linspace(np.min(u), L, 1000)
            else:
                l = np.linspace(0, L, 1000)

            distancebetweensupports = float(input('Enter distance between left support and right support in meters: '))
            while distancebetweensupports <= 0 or distancebetweensupports > L:
                distancebetweensupports = float(input('Invalid! Enter a valid distance: '))

            totalmoment = np.sum(P * x) + np.sum(w * span * (dis + (span / 2)))
            sumofforces = np.sum(P) + np.sum(w * span)
            ReactionatB = totalmoment / distancebetweensupports
            ReactionatA = sumofforces - ReactionatB
            V = ReactionatA * step_sf(l, 0) - np.sum([P[i] * step_sf(l, x[i]) for i in range(k)], axis=0) - np.sum([w[i] * lin_sf(l, dis[i]) for i in range(c)], axis=0) + np.sum([w[i] * lin_sf(l, dis[i] + span[i]) for i in range(c)], axis=0) + ReactionatB * step_sf(l, distancebetweensupports)
            M = ReactionatA * lin_sf(l, 0) - np.sum([P[i] * lin_sf(l, x[i]) for i in range(k)], axis=0) - np.sum([w[i] * quad_sf(l, dis[i]) for i in range(c)], axis=0) + np.sum([w[i] * quad_sf(l, dis[i] + span[i]) for i in range(c)], axis=0) + ReactionatB * lin_sf(l, distancebetweensupports)

            plt.subplot(211)
            plt.plot(l, V, 'r', linewidth=1.5)
            plt.axhline(0, color='k')
            plt.axvline(l[-1], color='r', linewidth=1.5)
            plt.xlabel('Distances in meters')
            plt.ylabel('Shear Force in kN')
            plt.title('Shear Force diagram')

            plt.subplot(212)
            plt.plot(l, M, 'r', linewidth=1.5)
            plt.axhline(0, color='k')
            plt.axvline(l[-1], color='r', linewidth=1.5)
            plt.xlabel('Distances in meters')
            plt.ylabel('Bending Moment in kNm')
            plt.title('Bending Moment Diagram')

            print(f'RA={ReactionatA:.2f} kN')
            print(f'RB={ReactionatB:.2f} kN')

            plt.show()

        elif n == 4:
            k = int(input('Enter the number of point loads: '))
            while k < 0:
                k = int(input('Invalid! Enter a valid number: '))

            P = np.zeros(k)
            x = np.zeros(k)
            for i in range(k):
                inputload = float(input('Enter the magnitude of the point load in kN: '))
                inputdistance = float(input('Enter its distance from the left support in meters: '))
                while inputdistance > L:
                    inputdistance = float(input('Invalid! Enter a valid length: '))
                P[i] = inputload
                x[i] = inputdistance

            c = int(input('Enter the number of UDLs: '))
            while c < 0:
                c = int(input('Invalid! Enter a valid number: '))

            w = np.zeros(c)
            span = np.zeros(c)
            dis = np.zeros(c)
            for i in range(c):
                wx = float(input('Enter the magnitude of the UDL in kN/m: '))
                spanx = float(input('Enter the span of the UDL in meters: '))
                while spanx <= 0 or spanx > L:
                    spanx = float(input('Invalid! Enter a valid span: '))
                disx = float(input('Enter the distance of the left end of UDL from the left support in meters: '))
                while disx >= L:
                    disx = float(input('Invalid! Enter a valid distance: '))
                w[i] = wx
                span[i] = spanx
                dis[i] = disx

            conc = int(input('Enter the number of concentrated moment(s): '))
            while conc < 0:
                conc = int(input('Invalid! Enter a valid number: '))

            concmoment = np.zeros(conc)
            concdistance = np.zeros(conc)
            for i in range(conc):
                cm = float(input('Enter magnitude of concentrated moment in kNm: '))
                cmdis = float(input('Enter its distance from the left support in meters: '))
                while cmdis > L:
                    cmdis = float(input('Invalid! Enter a valid distance: '))
                concmoment[i] = cm
                concdistance[i] = cmdis

            u = np.concatenate((x, dis, concdistance))
            if np.any(u < 0):
                L = L - abs(np.min(u))
                l = np.linspace(np.min(u), L, 1000)
            else:
                l = np.linspace(0, L, 1000)

            distancebetweensupports = float(input('Enter distance between left support and right support in meters: '))
            while distancebetweensupports <= 0 or distancebetweensupports > L:
                distancebetweensupports = float(input('Invalid! Enter a valid distance: '))

            totalmoment = np.sum(P * x) + np.sum(w * span * (dis + (span / 2))) + np.sum(concmoment)
            sumofforces = np.sum(P) + np.sum(w * span)
            ReactionatB = totalmoment / distancebetweensupports
            ReactionatA = sumofforces - ReactionatB
            V = ReactionatA * step_sf(l, 0) - np.sum([P[i] * step_sf(l, x[i]) for i in range(k)], axis=0) - np.sum([w[i] * lin_sf(l, dis[i]) for i in range(c)], axis=0) + np.sum([w[i] * lin_sf(l, dis[i] + span[i]) for i in range(c)], axis=0) + ReactionatB * step_sf(l, distancebetweensupports)
            M = ReactionatA * lin_sf(l, 0) - np.sum([P[i] * lin_sf(l, x[i]) for i in range(k)], axis=0) - np.sum([w[i] * quad_sf(l, dis[i]) for i in range(c)], axis=0) + np.sum([w[i] * quad_sf(l, dis[i] + span[i]) for i in range(c)], axis=0) + ReactionatB * lin_sf(l, distancebetweensupports) + np.sum([concmoment[i] * step_sf(l, concdistance[i]) for i in range(conc)], axis=0)

            plt.subplot(211)
            plt.plot(l, V, 'r', linewidth=1.5)
            plt.axhline(0, color='k')
            plt.axvline(l[-1], color='r', linewidth=1.5)
            plt.xlabel('Distances in meters')
            plt.ylabel('Shear Force in kN')
            plt.title('Shear Force diagram')

            plt.subplot(212)
            plt.plot(l, M, 'r', linewidth=1.5)
            plt.axhline(0, color='k')
            plt.axvline(l[-1], color='r', linewidth=1.5)
            plt.xlabel('Distances in meters')
            plt.ylabel('Bending Moment in kNm')
            plt.title('Bending Moment Diagram')

            print(f'RA={ReactionatA:.2f} kN')
            print(f'RB={ReactionatB:.2f} kN')

            plt.show()

    elif choice == 2:
        print('1. Cantilever with only point loads on the span')
        print('2. Cantilever with only UDL(s) across the span')
        print('3. Cantilever with point load(s) and UDL(s) across the span')
        print('4. Cantilever with point load(s), UDL(s) and concentrated moment(s) across the span')
        n = int(input('Please select any of the above: '))
        while n < 1 or n > 4:
            n = int(input('Invalid! Select a valid choice: '))

        L = float(input('Enter the length of the beam: '))
        while L <= 0:
            L = float(input('Invalid! Enter a valid length: '))

        if n == 1:
            k = int(input('Enter the number of point loads: '))
            while k < 0:
                k = int(input('Invalid! Enter a valid number: '))

            P = np.zeros(k)
            x = np.zeros(k)
            for i in range(k):
                inputload = float(input('Enter the magnitude of the point load in kN: '))
                inputdistance = float(input('Enter its distance from the support in meters: '))
                while inputdistance > L or inputdistance < 0:
                    inputdistance = float(input('Invalid! Enter a valid length: '))
                P[i] = inputload
                x[i] = inputdistance

            l = np.linspace(0, L, 1000)
            sumofforces = np.sum(P)
            RA = sumofforces
            sumofmoments = np.sum(P * x)
            MA = sumofmoments
            V = RA * step_sf(l, 0) - np.sum([P[i] * step_sf(l, x[i]) for i in range(k)], axis=0)
            M = MA * step_sf(l, 0) - RA * lin_sf(l, 0) + np.sum([P[i] * lin_sf(l, x[i]) for i in range(k)], axis=0)

            plt.subplot(211)
            plt.plot(l, V, 'r', linewidth=1.5)
            plt.axhline(0, color='k')
            plt.axvline(l[-1], color='r', linewidth=1.5)
            plt.xlabel('Distances in meters')
            plt.ylabel('Shear Force in kN')
            plt.title('Shear Force diagram')

            plt.subplot(212)
            plt.plot(l, M, 'r', linewidth=1.5)
            plt.axhline(0, color='k')
            plt.axvline(l[-1], color='r', linewidth=1.5)
            plt.xlabel('Distances in meters')
            plt.ylabel('Bending Moment in kNm')
            plt.title('Bending Moment Diagram')

            print(f'RA={RA:.2f} kN')
            print(f'MA={MA:.2f} kNm')

            plt.show()

        elif n == 2:
            k = int(input('Enter the number of UDLs: '))
            while k < 0:
                k = int(input('Invalid! Enter a valid number: '))

            w = np.zeros(k)
            span = np.zeros(k)
            dis = np.zeros(k)
            for i in range(k):
                wx = float(input('Enter the magnitude of the UDL in kN/m: '))
                spanx = float(input('Enter the span of the UDL in meters: '))
                while spanx <= 0 or spanx > L:
                    spanx = float(input('Invalid! Enter a valid span'))
                disx = float(input('Enter the distance of the left end of UDL from the support in meters: '))
                while disx < 0 or disx >= L:
                    disx = float(input('Invalid! Enter a valid distance: '))
                w[i] = wx
                span[i] = spanx
                dis[i] = disx

            l = np.linspace(0, L, 1000)
            intensityofUDL = np.sum(w * span)
            centroid = dis + (span / 2)
            sumofmoments = np.sum(intensityofUDL * centroid)
            RA = intensityofUDL
            MA = sumofmoments
            V = RA * step_sf(l, 0) - np.sum([w[i] * lin_sf(l, dis[i]) for i in range(k)], axis=0) + np.sum([w[i] * lin_sf(l, dis[i] + span[i]) for i in range(k)], axis=0)
            M = MA * step_sf(l, 0) - RA * lin_sf(l, 0) + np.sum([w[i] * quad_sf(l, dis[i]) for i in range(k)], axis=0) - np.sum([w[i] * quad_sf(l, dis[i] + span[i]) for i in range(k)], axis=0)

            plt.subplot(211)
            plt.plot(l, V, 'r', linewidth=1.5)
            plt.axhline(0, color='k')
            plt.axvline(l[-1], color='r', linewidth=1.5)
            plt.xlabel('Distances in meters')
            plt.ylabel('Shear Force in kN')
            plt.title('Shear Force diagram')

            plt.subplot(212)
            plt.plot(l, M, 'r', linewidth=1.5)
            plt.axhline(0, color='k')
            plt.axvline(l[-1], color='r', linewidth=1.5)
            plt.xlabel('Distances in meters')
            plt.ylabel('Bending Moment in kNm')
            plt.title('Bending Moment Diagram')

            print(f'RA={RA:.2f} kN')
            print(f'MA={MA:.2f} kNm')

            plt.show()

        elif n == 3:
            k = int(input('Enter the number of point loads: '))
            while k < 0:
                k = int(input('Invalid! Enter a valid number: '))

            P = np.zeros(k)
            x = np.zeros(k)
            for i in range(k):
                inputload = float(input('Enter the magnitude of the point load in kN: '))
                inputdistance = float(input('Enter its distance from the support in meters: '))
                P[i] = inputload
                x[i] = inputdistance

            k = int(input('Enter the number of UDLs: '))
            while k < 0:
                k = int(input('Invalid! Enter a valid number: '))

            w = np.zeros(k)
            span = np.zeros(k)
            dis = np.zeros(k)
            for i in range(k):
                wx = float(input('Enter the magnitude of the UDL in kN/m: '))
                spanx = float(input('Enter the span of the UDL in meters: '))
                while spanx <= 0 or spanx > L:
                    spanx = float(input('Invalid! Enter a valid span: '))
                disx = float(input('Enter the distance of the left end of UDL from the support in meters: '))
                while disx < 0 or disx >= L:
                    disx = float(input('Invalid! Enter a valid distance: '))
                w[i] = wx
                span[i] = spanx
                dis[i] = disx

            l = np.linspace(0, L, 1000)
            sumofforces = np.sum(P) + np.sum(w * span)
            totalmoments = np.sum(P * x) + np.sum(w * span * (dis + (span / 2)))
            RA = sumofforces
            MA = totalmoments
            V = RA * step_sf(l, 0) - np.sum([P[i] * step_sf(l, x[i]) for i in range(k)], axis=0) - np.sum([w[i] * lin_sf(l, dis[i]) for i in range(k)], axis=0) + np.sum([w[i] * lin_sf(l, dis[i] + span[i]) for i in range(k)], axis=0)
            M = MA * step_sf(l, 0) - RA * lin_sf(l, 0) + np.sum([P[i] * lin_sf(l, x[i]) for i in range(k)], axis=0) + np.sum([w[i] * quad_sf(l, dis[i]) for i in range(k)], axis=0) - np.sum([w[i] * quad_sf(l, dis[i] + span[i]) for i in range(k)], axis=0)

            plt.subplot(211)
            plt.plot(l, V, 'r', linewidth=1.5)
            plt.axhline(0, color='k')
            plt.axvline(l[-1], color='r', linewidth=1.5)
            plt.xlabel('Distances in meters')
            plt.ylabel('Shear Force in kN')
            plt.title('Shear Force diagram')

            plt.subplot(212)
            plt.plot(l, M, 'r', linewidth=1.5)
            plt.axhline(0, color='k')
            plt.axvline(l[-1], color='r', linewidth=1.5)
            plt.xlabel('Distances in meters')
            plt.ylabel('Bending Moment in kNm')
            plt.title('Bending Moment Diagram')

            print(f'RA={RA:.2f} kN')
            print(f'MA={MA:.2f} kNm')

            plt.show()

        elif n == 4:
            k = int(input('Enter the number of point loads: '))
            while k < 0:
                k = int(input('Invalid! Enter a valid number: '))

            P = np.zeros(k)
            x = np.zeros(k)
            for i in range(k):
                inputload = float(input('Enter the magnitude of the point load in kN: '))
                inputdistance = float(input('Enter its distance from the support in meters: '))
                while inputdistance < 0 or inputdistance > L:
                    inputdistance = float(input('Invalid! Enter a valid distance: '))
                P[i] = inputload
                x[i] = inputdistance

            k = int(input('Enter the number of UDLs: '))
            while k < 0:
                k = int(input('Invalid! Enter a valid number: '))

            w = np.zeros(k)
            span = np.zeros(k)
            dis = np.zeros(k)
            for i in range(k):
                wx = float(input('Enter the magnitude of the UDL in kN/m: '))
                spanx = float(input('Enter the span of the UDL in meters: '))
                while spanx <= 0 or spanx > L:
                    spanx = float(input('Invalid! Enter a valid span: '))
                disx = float(input('Enter the distance of the left end of UDL from the support in meters: '))
                while disx < 0 or disx >= L:
                    disx = float(input('Invalid! Enter a valid distance: '))
                w[i] = wx
                span[i] = spanx
                dis[i] = disx

            conc = int(input('Enter the number of concentrated moment(s): '))
            while conc < 0:
                conc = int(input('Invalid! Enter a valid number: '))

            concmoment = np.zeros(conc)
            concdistance = np.zeros(conc)
            for i in range(conc):
                cm = float(input('Enter magnitude of concentrated moment in kNm: '))
                cmdis = float(input('Enter its distance from the support in meters: '))
                while cmdis > L:
                    cmdis = float(input('Invalid! Enter a valid distance: '))
                concmoment[i] = cm
                concdistance[i] = cmdis

            l = np.linspace(0, L, 1000)
            sumofforces = np.sum(P) + np.sum(w * span)
            totalmoments = np.sum(P * x) + np.sum(w * span * (dis + (span / 2))) + np.sum(concmoment)
            RA = sumofforces
            MA = totalmoments
            V = RA * step_sf(l, 0) - np.sum([P[i] * step_sf(l, x[i]) for i in range(k)], axis=0) - np.sum([w[i] * lin_sf(l, dis[i]) for i in range(k)], axis=0) + np.sum([w[i] * lin_sf(l, dis[i] + span[i]) for i in range(k)], axis=0)
            M = MA * step_sf(l, 0) - RA * lin_sf(l, 0) + np.sum([P[i] * lin_sf(l, x[i]) for i in range(k)], axis=0) + np.sum([w[i] * quad_sf(l, dis[i]) for i in range(k)], axis=0) - np.sum([w[i] * quad_sf(l, dis[i] + span[i]) for i in range(k)], axis=0) - np.sum([concmoment[i] * step_sf(l, concdistance[i]) for i in range(conc)], axis=0)

            plt.subplot(211)
            plt.plot(l, V, 'r', linewidth=1.5)
            plt.axhline(0, color='k')
            plt.axvline(l[-1], color='r', linewidth=1.5)
            plt.xlabel('Distances in meters')
            plt.ylabel('Shear Force in kN')
            plt.title('Shear Force diagram')

            plt.subplot(212)
            plt.plot(l, M, 'r', linewidth=1.5)
            plt.axhline(0, color='k')
            plt.axvline(l[-1], color='r', linewidth=1.5)
            plt.xlabel('Distances in meters')
            plt.ylabel('Bending Moment in kNm')
            plt.title('Bending Moment Diagram')

            print(f'RA={RA:.2f} kN')
            print(f'MA={MA:.2f} kNm')

            plt.show()

if __name__ == '__main__':
    main()
