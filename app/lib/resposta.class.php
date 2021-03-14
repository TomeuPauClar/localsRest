<?php

namespace App\Lib;

class Resposta
{
	public $dades    = null;
	public $correcta = false;
	public $missatge = '';
	public $rowcount = '';

	public function SetCorrecta($correcta, $m = '', $rc = 0)
	{
		$this->correcta = $correcta;
		$this->missatge = $m;
		$this->rowcount = $rc;

		if (!$correcta && $m = '') {
			$this->missatge = 'Hi ha hagut un error inesperat';
		}
	}

	public function SetDades($dades)
	{
		$this->dades = $dades;
	}
}
