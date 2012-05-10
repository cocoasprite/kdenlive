 /*
Copyright (C) 2012  Till Theato <root@ttill.de>
This file is part of kdenlive. See www.kdenlive.org.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
*/
 
#ifndef EFFECT_H
#define EFFECT_H

#include "core/effectsystem/abstractparameterlist.h"
#include <mlt++/Mlt.h>

class EffectDescription;
class AbstractEffectList;


class Effect : public AbstractParameterList
{
    Q_OBJECT

public:
    Effect(EffectDescription *effectDescription, AbstractEffectList* parent = 0);
    ~Effect();

    void setParameter(QString name, QString value);
    QString getParameter(QString name) const;

    virtual void setProperty(QString name, QString value);
    virtual QString getProperty(QString name) const;

    void checkPropertiesViewState();
    void checkTimelineViewState();
    void checkMonitorViewState();

private:
    Mlt::Filter *m_filter;
    EffectDescription *m_description;
};

#endif
