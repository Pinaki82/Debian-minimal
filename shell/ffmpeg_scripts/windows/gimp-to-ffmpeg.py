import re
from argparse import ArgumentParser

def read_curves(f):
	points = {}
	for line in f.readlines():
		line=line.strip()
		if line.startswith("(channel "):
			ch=re.match(r'\(channel (\w+)\)', line).group(1)
		elif line.startswith("(points "):
			co = [float(m.group(1)) for m in re.finditer(r'\b([0-9.]+)\b', line)]
			co = list(zip(co[1::2], co[2::2]))
			points[ch] = co
	return points

def ffmpeg_points(points):
	return ' '.join('{0}/{1}'.format(x,y) for x,y in points)

def main():
	ap = ArgumentParser()
	ap.add_argument("input")
	ap.add_argument("-q", "--quote", action='store_true')
	a = ap.parse_args()
	with open(a.input, "r") as f:
		points = read_curves(f)
	ffp=[
		ffmpeg_points(points['value']),
		ffmpeg_points(points['red']),
		ffmpeg_points(points['green']),
		ffmpeg_points(points['blue'])
	]
	if a.quote:
		print("curves=m='{0}':r='{1}':g='{2}':b='{3}'".format(*ffp))
	else:
		print("curves=m={0}:r={1}:g={2}:b={3}".format(*ffp))

main()

