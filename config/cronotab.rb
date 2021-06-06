# frozen_string_literal: true

Crono.perform(JRAJob).every 1.week, on: :saturday, at: '00:00'
Crono.perform(JRAJob).every 1.week, on: :sunday, at: '00:00'

Crono.perform(NankanJob).every 1.week, on: :monday, at: '02:00'
Crono.perform(NankanJob).every 1.week, on: :tuesday, at: '02:00'
Crono.perform(NankanJob).every 1.week, on: :wednesday, at: '02:00'
Crono.perform(NankanJob).every 1.week, on: :thursday, at: '02:00'
Crono.perform(NankanJob).every 1.week, on: :friday, at: '02:00'
