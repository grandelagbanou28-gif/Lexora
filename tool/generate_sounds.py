"""Generate short sound effect WAV files for Lexora (stdlib only)."""

import math
import os
import struct
import wave

RATE = 22050
OUT_DIR = os.path.join(os.path.dirname(__file__), '..', 'assets', 'sounds')


def _samples(duration):
    return int(RATE * duration)


def _sine(freq, seconds, amp=0.6, decay=6.0):
    count = _samples(seconds)
    out = []
    for i in range(count):
        t = i / RATE
        env = min(1.0, math.exp(-decay * t))
        out.append(amp * env * math.sin(2 * math.pi * freq * t))
    return out


def _mix(*parts, seconds=None):
    if seconds is None:
        seconds = max(len(p) for p in parts) / RATE
    count = _samples(seconds)
    out = [0.0] * count
    for part in parts:
        for i, v in enumerate(part):
            if i < count:
                out[i] += v
    return out


def _concat(*parts):
    return [v for part in parts for v in part]


def _clamp(x):
    if x > 1.0:
        return 1.0
    if x < -1.0:
        return -1.0
    return x


def write(name, samples):
    path = os.path.join(OUT_DIR, name)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    frames = bytearray()
    for value in samples:
        data = struct.pack('<h', int(_clamp(value) * 32767))
        frames += data
    with wave.open(path, 'wb') as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(RATE)
        w.writeframes(bytes(frames))
    print(f'wrote {os.path.basename(path)} ({len(frames)} bytes)')


def key_press():
    write('key_press.wav', _sine(420, 0.055, amp=0.35, decay=22))


def enter():
    write('enter.wav', _sine(520, 0.10, amp=0.45, decay=14))


def correct():
    write('correct.wav', _concat(_sine(660, 0.09, decay=12), _sine(880, 0.14, decay=9)))


def wrong_spot():
    write('wrong_spot.wav', _sine(500, 0.13, amp=0.4, decay=10))


def not_in_word():
    write('not_in_word.wav', _sine(230, 0.16, amp=0.4, decay=8))


def win():
    write(
        'win.wav',
        _concat(
            _sine(523.25, 0.12, decay=10),
            _sine(659.25, 0.12, decay=10),
            _sine(783.99, 0.12, decay=10),
            _sine(1046.5, 0.22, decay=7),
        ),
    )


def lose():
    write(
        'lose.wav',
        _concat(
            _sine(392.0, 0.14, decay=10),
            _sine(329.63, 0.14, decay=10),
            _sine(261.63, 0.24, decay=7),
        ),
    )


def level_up():
    write(
        'level_up.wav',
        _concat(
            _sine(523.25, 0.10, decay=12),
            _sine(659.25, 0.10, decay=12),
            _sine(783.99, 0.10, decay=12),
            _sine(1046.5, 0.10, decay=12),
            _sine(523.25, 0.18, decay=8),
            _sine(1046.5, 0.24, decay=7),
        ),
    )


def tokens():
    write(
        'tokens.wav',
        _concat(
            _sine(987.77, 0.09, amp=0.45, decay=16),
            _sine(1318.5, 0.16, amp=0.35, decay=9),
        ),
    )


def achievement():
    write(
        'achievement.wav',
        _concat(
            _sine(1568.0, 0.09, amp=0.32, decay=18),
            _sine(2093.0, 0.07, amp=0.28, decay=18),
            _sine(2637.0, 0.16, amp=0.24, decay=12),
        ),
    )


def challenge_complete():
    write(
        'challenge_complete.wav',
        _concat(
            _sine(880.0, 0.09, amp=0.42, decay=16),
            _sine(1318.5, 0.18, amp=0.32, decay=10),
        ),
    )


def challenge_all():
    write(
        'challenge_all.wav',
        _concat(
            _sine(659.25, 0.10, decay=12),
            _sine(783.99, 0.10, decay=12),
            _sine(1046.5, 0.10, decay=12),
            _sine(1318.5, 0.28, decay=8),
        ),
    )


def streak_milestone():
    write(
        'streak_milestone.wav',
        _concat(
            _sine(523.25, 0.10, decay=14),
            _sine(659.25, 0.10, decay=14),
            _sine(783.99, 0.12, decay=10),
            _sine(1046.5, 0.12, decay=10),
            _sine(1568.0, 0.26, decay=8),
        ),
    )


def coins():
    write(
        'coins.wav',
        _concat(
            _sine(987.77, 0.06, amp=0.38, decay=22),
            _sine(1318.5, 0.06, amp=0.34, decay=22),
            _sine(1760.0, 0.10, amp=0.30, decay=16),
        ),
    )


def jackpot():
    write(
        'jackpot.wav',
        _concat(
            _sine(523.25, 0.09, decay=12),
            _sine(659.25, 0.09, decay=12),
            _sine(783.99, 0.09, decay=12),
            _sine(1046.5, 0.09, decay=12),
            _sine(1318.5, 0.09, decay=12),
            _mix(
                _sine(523.25, 0.32, amp=0.30, decay=6),
                _sine(659.25, 0.32, amp=0.30, decay=6),
                _sine(783.99, 0.32, amp=0.30, decay=6),
                _sine(1046.5, 0.32, amp=0.26, decay=6),
                seconds=0.32,
            ),
        ),
    )


def main():
    key_press()
    enter()
    correct()
    wrong_spot()
    not_in_word()
    win()
    lose()
    level_up()
    tokens()
    achievement()
    challenge_complete()
    challenge_all()
    streak_milestone()
    coins()
    jackpot()


if __name__ == '__main__':
    main()